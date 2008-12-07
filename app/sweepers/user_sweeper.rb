class UserSweeper < ActionController::Caching::Sweeper
  
  include SweepingHelper
  
  observe User

  def after_create(user)
    expire_all(user)
  end
  
  def after_update(user)
    expire_all(user) if user.changed?
  end
  
  def after_destroy(user)
    expire_all(user)
  end
  
  
  private  
  
  def expire_all(user)
    user.blogs.each do |blog|
      SweepingHelper::sweep_path("blogs/#{blog.id}/users")
      expire_page(:controller => "blogs/#{blog.id}", :action => 'users')
    end
  end
  
end