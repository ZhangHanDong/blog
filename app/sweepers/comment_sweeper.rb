class CommentSweeper < ActionController::Caching::Sweeper
  
  observe Comment

  def after_create(comment)
  end
  
  def after_update(comment)
  end
  
  def after_destroy(comment)
  end
  
end