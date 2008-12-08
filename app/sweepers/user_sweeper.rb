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
    # expire user posts
    # expire user comments
    # expire blog user listings
  end
  
end