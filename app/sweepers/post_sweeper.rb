class PostSweeper < ActionController::Caching::Sweeper
  
  observe Post

  def after_create(post)
    expire_all(post)
  end
  
  def after_update(post)
    expire_all(post) if post.changed?
  end
  
  def after_destroy(post)
    expire_all(post, true)
  end
  
  
  private
  
  def expire_all(post, destroying = false)
    # permalink
    expire_page(:controller => '/posts', :action => 'permalink', :year => post.publish_date.year, 
                                                                 :month => post.publish_date.month, 
                                                                 :day => post.publish_date.day, 
                                                                 :permalink => post.permalink)    
    
    expire_date_pages(post, post.publish_date)
        
    # blog post comments + pages
    if post.title_changed? || destroying
      expire_page(:controller => '/comments', :action => 'index', :post_id => post.id)
      expire_page(:controller => '/comments', :action => 'index', :post_id => post.id, :format => :atom)
      SweepingHelper::sweep_path("blogs/#{post.blog_id}/posts/#{post.id}/comments/page")
    end
    
    # blog posts + pages
    expire_page(:controller => '/posts', :action => 'index', :blog_id => post.blog_id)
    expire_page(:controller => '/posts', :action => 'index', :blog_id => post.blog_id, :format => :atom)
    SweepingHelper::sweep_path("blogs/#{post.blog_id}/posts/page")
    
    # blog user posts + pages
    expire_page(:controller => '/posts', :action => 'index', :blog_id => post.blog_id, :user_id => post.user_id)
    expire_page(:controller => '/posts', :action => 'index', :blog_id => post.blog_id, :user_id => post.user_id, :format => :atom)
    SweepingHelper::sweep_path("blogs/#{post.blog_id}/users/#{post.user_id}/posts/page")
     
    # if tags changed, clear old and new tag urls using cached_tag_list
    if post.changes['cached_tag_list']
      expire_tags = Tag.parse(post.changes['cached_tag_list'].first) || []
      new_tags = Tag.parse(post.changes['cached_tag_list'].last) || []
      expire_tag_pages(post, new_tags.concat(expire_tags)) 
    elsif post.tags && destroying
      current_tags = Tag.parse(post.cached_tag_list) || []
      expire_tag_pages(post, current_tags)
    end
    
    # if date changed, clear older date pages
    if post.changes['publish_date'] && post.changes['publish_date'].first
      expire_date_pages(post, post.changes['publish_date'].first)
    end  
  end
  
  def expire_tag_pages(post, tag_names)
    tag_names.uniq.each do |tag_name|
      tag = Tag.find_by_name(tag_name)
      if tag
        expire_page(:controller => '/posts', :action => 'tagged', :blog_id => post.blog_id, :tag => tag.name)
        expire_page(:controller => '/posts', :action => 'tagged', :blog_id => post.blog_id, :tag => tag.name, :format => :atom)
        SweepingHelper::sweep_path("blogs/#{post.blog_id}/#{tag.name}/page")

        expire_page(:controller => '/posts', :action => 'index', :blog_id => post.blog_id, :tag_id => tag.id)
        expire_page(:controller => '/posts', :action => 'index', :blog_id => post.blog_id, :tag_id => tag.id, :format => :atom)
        SweepingHelper::sweep_path("blogs/#{post.blog_id}/tags/#{tag.id}/posts/page")
      end
    end
  end
  
  def expire_date_pages(post, expire_date)
    # day + pages 
    expire_page(:controller => '/posts', :action => 'on', :year => expire_date.year, :month => expire_date.month, :day => expire_date.day)           
    SweepingHelper::sweep_path("blogs/#{post.blog_id}/#{expire_date.year}/#{expire_date.month}/#{expire_date.day}")                                                       
    
    # month + pages
    expire_page(:controller => '/posts', :action => 'on', :year => expire_date.year, :month => expire_date.month)
    SweepingHelper::sweep_path("blogs/#{post.blog_id}/#{expire_date.year}/#{expire_date.month}")                                                          
    
    # year + pages
    expire_page(:controller => '/posts', :action => 'on', :year => expire_date.year)
    SweepingHelper::sweep_path("blogs/#{post.blog_id}/#{expire_date.year}")
  end
  
end