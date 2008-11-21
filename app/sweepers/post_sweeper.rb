class PostSweeper < ActionController::Caching::Sweeper
  
  observe Post

  def after_create(post)
  end
  
  def after_update(post)
  end
  
  def after_destroy(post)
  end
  
end