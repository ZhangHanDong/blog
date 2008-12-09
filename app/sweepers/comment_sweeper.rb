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
    post = comment.post || Post.find(comment.post_id)

    # expire blog post comments
    if post
      expire_page(:controller => '/comments', :action => 'index', :blog_id => post.blog_id, :post_id => comment.post_id)
      expire_page(:controller => '/comments', :action => 'index', :blog_id => post.blog_id, :post_id => comment.post_id, :format => :atom)
      SweepingHelper::sweep_path("blogs/#{post.blog_id}/posts/#{comment.post_id}/comments/page")
    end
    
    # expire blog user comments
    if comment.user_id
      expire_page(:controller => '/comments', :action => 'index', :blog_id => post.blog_id, :user_id => comment.user_id)
      expire_page(:controller => '/comments', :action => 'index', :blog_id => post.blog_id, :user_id => comment.user_id, :format => :atom)
      SweepingHelper::sweep_path("blogs/#{post.blog_id}/users/#{comment.user_id}/comments/page")
    end
    
    # expire blog comments
    expire_page(:controller => '/comments', :action => 'index', :blog_id => post.blog_id)
    expire_page(:controller => '/comments', :action => 'index', :blog_id => post.blog_id, :format => :atom)
    SweepingHelper::sweep_path("blogs/#{post.blog_id}/comments/page")
  end
  
end