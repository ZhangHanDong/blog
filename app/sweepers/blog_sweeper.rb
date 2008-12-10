class BlogSweeper < ActionController::Caching::Sweeper
  
  include SweepingHelper
  
  observe Blog

  def after_create(blog)
    expire_all(blog, true) if !blog.in_draft
  end
  
  def after_update(blog)
    if blog.changed? && (blog.in_draft_changed? || !blog.in_draft)
      expire_all(blog) 
    end
  end
  
  def after_destroy(blog)
    expire_all(blog)
  end
  

  private  
  
  def expire_all(blog, creating = false)
    # entire blog
    SweepingHelper::sweep_path("blogs/#{blog.id}") unless creating
    # index + pages
    expire_page(:controller => '/blogs', :action => 'index')
    expire_page(:controller => '/', :action => 'index')
    SweepingHelper::sweep_path("blogs/page")
  end
    
end