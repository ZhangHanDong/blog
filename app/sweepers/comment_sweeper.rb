class CommentSweeper < ActionController::Caching::Sweeper
  
  include SweepingHelper
  
  observe Comment

  def after_create(comment)
    expire_all(comment)
  end
  
  def after_update(comment)
    expire_all(comment) if comment.changed?
  end
  
  def after_destroy(comment)
    expire_all(comment)
  end
  
   
  private  
  
  def expire_all(comment)
    # expire blog post comments
    expire_page(:controller => '/comments', :action => 'index', :blog_id => comment.post.blog_id, :post_id => comment.post.id)
    expire_page(:controller => '/comments', :action => 'index', :blog_id => comment.post.blog_id, :post_id => comment.post.id, :format => :atom)
    SweepingHelper::sweep_path("blogs/#{comment.post.blog_id}/posts/#{comment.post.id}/comments/page")
    
    # expire blog comments
    expire_page(:controller => '/comments', :action => 'index', :blog_id => comment.post.blog_id)
    expire_page(:controller => '/comments', :action => 'index', :blog_id => comment.post.blog_id, :format => :atom)
    SweepingHelper::sweep_path("blogs/#{comment.post.blog_id}/comments/page")
    
    # expire blog user comments
    if comment.user
      expire_page(:controller => '/comments', :action => 'index', :blog_id => comment.post.blog_id, :user_id => comment.user.id)
      expire_page(:controller => '/comments', :action => 'index', :blog_id => comment.post.blog_id, :user_id => comment.user.id, :format => :atom)
      SweepingHelper::sweep_path("blogs/#{comment.post.blog_id}/users/#{comment.user.id}/comments/page")
    end
    
  end
  
end