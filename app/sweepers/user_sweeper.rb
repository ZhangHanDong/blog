class UserSweeper < ActionController::Caching::Sweeper
  
  include SweepingHelper
  
  observe User

  def after_create(user)
    # not user activity yet - nothing to expire
  end
  
  def after_update(user)
    expire_all(user) if user.changed?
  end
  
  def after_destroy(user)
    expire_all(user)
  end
  
  
  private  
  
  def expire_all(user)
    # user commments
    
    # user posts
    
    # user listings
    user.blogs.each do |blog|
      expire_page(:controller => '/users', :action => 'show', :blog_id => blog.id, :user_id => user.id)
      expire_page(:controller => '/users', :action => 'index', :blog_id => blog.id)
      SweepingHelper::sweep_path("blogs/#{blog.id}/users/page")
    end
  end
  
end