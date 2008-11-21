class TagSweeper < ActionController::Caching::Sweeper
  
  observe Tag

  def after_create(tag)
  end
  
  def after_update(tag)
  end
  
  def after_destroy(tag)
  end
  
end