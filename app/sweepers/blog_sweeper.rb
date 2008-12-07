class BlogSweeper < ActionController::Caching::Sweeper
  
  include SweepingHelper
  
  observe Blog

  def after_create(blog)
    expire_all(blog)
  end
  
  def after_update(blog)
    expire_all(blog) if blog.changed?
  end
  
  def after_destroy(blog)
    expire_all(blog)
  end
  

  private  
  
  def expire_all(blog)
    SweepingHelper::sweep_path("blogs/#{blog.id}")
    SweepingHelper::sweep_path("blogs/page")
    expire_page(:controller => '/blogs', :action => 'index')
    expire_page(:controller => '/', :action => 'index')
  end
    
end