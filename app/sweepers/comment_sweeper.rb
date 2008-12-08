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
    # expire blog user comments
    # expire blog comments
  end
  
end