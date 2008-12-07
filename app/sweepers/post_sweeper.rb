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
    
    # day + pages
    expire_page(:controller => '/posts', :action => 'on', :year => post.publish_date.year,
                                                          :month => post.publish_date.month,
                                                          :day => post.publish_date.day)           
    SweepingHelper::sweep_path("blogs/#{post.blog.id}/#{post.publish_date.year}/#{post.publish_date.month}/#{post.publish_date.day}")
    
                                                         
    # month + pages
    expire_page(:controller => '/posts', :action => 'on', :year => post.publish_date.year,
                                                          :month => post.publish_date.month)
    SweepingHelper::sweep_path("blogs/#{post.blog.id}/#{post.publish_date.year}/#{post.publish_date.month}")
                                                          
    # year + pages
    expire_page(:controller => '/posts', :action => 'on', :year => post.publish_date.year)
    SweepingHelper::sweep_path("blogs/#{post.blog.id}/#{post.publish_date.year}")
        
    # blog post comments
    expire_page(:controller => '/comments', :action => 'index', :post_id => post.id)
    expire_page(:controller => '/comments', :action => 'index', :post_id => post.id, :format => :atom)
    
    # blog posts
    expire_page(:controller => '/posts', :action => 'index', :blog_id => post.blog.id)
    expire_page(:controller => '/posts', :action => 'index', :blog_id => post.blog.id, :format => :atom)
    SweepingHelper::sweep_path("blogs/#{post.blog.id}/posts/page")
    
    # blog user posts
    expire_page(:controller => '/posts', :action => 'index', :blog_id => post.blog.id, :user_id => post.user.id)
    expire_page(:controller => '/posts', :action => 'index', :blog_id => post.blog.id, :user_id => post.user.id, :format => :atom)
    SweepingHelper::sweep_path("blogs/#{post.blog.id}/users/#{post.user.id}/posts/page")
    
    # blog tagged posts
    post.tags.each do |tag|
      expire_page(:controller => '/posts', :action => 'index', :blog_id => post.blog.id, :tag_id => tag.id)
      expire_page(:controller => '/posts', :action => 'index', :blog_id => post.blog.id, :tag_id => tag.id, :format => :atom)
      SweepingHelper::sweep_path("blogs/#{post.blog.id}/tags/#{tag.id}/posts/page")
      
      expire_page(:controller => '/posts', :action => 'tagged', :blog_id => post.blog.id, :tag => tag.name)
      expire_page(:controller => '/posts', :action => 'tagged', :blog_id => post.blog.id, :tag => tag.name, :format => :atom)
      SweepingHelper::sweep_path("blogs/#{post.blog.id}/#{tag.name}/page")
    end
    
    # (and older dates & tags ??)
    
    
  end
  
end