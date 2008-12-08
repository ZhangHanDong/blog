class PostSweeper < ActionController::Caching::Sweeper
  
  observe Post

  def after_create(post)
    expire_all(post)
  end
  
  def after_update(post)
    expire_all(post) if post.changed?
  end
  
  def after_destroy(post)
    expire_all(post)
  end
  
  
  private
  
  def expire_all(post)
    # permalink
    expire_page(:controller => '/posts', :action => 'permalink', :year => post.publish_date.year, 
                                                                 :month => post.publish_date.month, 
                                                                 :day => post.publish_date.day, 
                                                                 :permalink => post.permalink)    
    
    expire_date_pages(post, post.publish_date)
        
    # blog post comments + pages
    expire_page(:controller => '/comments', :action => 'index', :post_id => post.id)
    expire_page(:controller => '/comments', :action => 'index', :post_id => post.id, :format => :atom)
    SweepingHelper::sweep_path("blogs/#{post.blog.id}/posts/#{post.id}/comments/page")
    
    # blog posts + pages
    expire_page(:controller => '/posts', :action => 'index', :blog_id => post.blog.id)
    expire_page(:controller => '/posts', :action => 'index', :blog_id => post.blog.id, :format => :atom)
    SweepingHelper::sweep_path("blogs/#{post.blog.id}/posts/page")
    
    # blog user posts + pages
    expire_page(:controller => '/posts', :action => 'index', :blog_id => post.blog.id, :user_id => post.user.id)
    expire_page(:controller => '/posts', :action => 'index', :blog_id => post.blog.id, :user_id => post.user.id, :format => :atom)
    SweepingHelper::sweep_path("blogs/#{post.blog.id}/users/#{post.user.id}/posts/page")
    
    # if tags changed, clear old and new tag urls using cached_tag_list
    if post.changes['cached_tag_list'] && post.changes['cached_tag_list'].first
      expire_tags = Tag.parse(post.changes['cached_tag_list'].first) || []
      new_tags = Tag.parse(post.changes['cached_tag_list'].last) || []
      uniq_tags = new_tags.concat(expire_tags).uniq!
      
      if uniq_tags
        uniq_tags.each do |tag_name|
          tag = Tag.find_by_name(tag_name)
          if tag
            # only need to clear cache if tag name already exists
            expire_page(:controller => '/posts', :action => 'tagged', :blog_id => post.blog.id, :tag => tag_name)
            expire_page(:controller => '/posts', :action => 'tagged', :blog_id => post.blog.id, :tag => tag_name, :format => :atom)
            SweepingHelper::sweep_path("blogs/#{post.blog.id}/#{tag_name}/page")
            
            expire_page(:controller => '/posts', :action => 'index', :blog_id => post.blog.id, :tag_id => tag.id)
            expire_page(:controller => '/posts', :action => 'index', :blog_id => post.blog.id, :tag_id => tag.id, :format => :atom)
            SweepingHelper::sweep_path("blogs/#{post.blog.id}/tags/#{tag.id}/posts/page")
          end
        end  
      end
    end
    
    # if date changed, clear older date pages
    if post.changes['publish_date'] && post.changes['publish_date'].first
      expire_date_pages(post, post.changes['publish_date'].first)
    end  
  end
  
  def expire_date_pages(post, expire_date)
    # day + pages 
    expire_page(:controller => '/posts', :action => 'on', :year => expire_date.year, :month => expire_date.month, :day => expire_date.day)           
    SweepingHelper::sweep_path("blogs/#{post.blog.id}/#{expire_date.year}/#{expire_date.month}/#{expire_date.day}")                                                       
    
    # month + pages
    expire_page(:controller => '/posts', :action => 'on', :year => expire_date.year, :month => expire_date.month)
    SweepingHelper::sweep_path("blogs/#{post.blog.id}/#{expire_date.year}/#{expire_date.month}")                                                          
    
    # year + pages
    expire_page(:controller => '/posts', :action => 'on', :year => expire_date.year)
    SweepingHelper::sweep_path("blogs/#{post.blog.id}/#{expire_date.year}")
  end
  
end