class BlogSweeper < ActionController::Caching::Sweeper
  
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
  
  def self.sweep(path)
    cache_dir = ActionController::Base.page_cache_directory
    unless cache_dir == RAILS_ROOT+"/public"
      FileUtils.rm_r(Dir.glob(cache_dir+"/#{path}/*")) rescue Errno::ENOENT
      RAILS_DEFAULT_LOGGER.info("Expired path: #{path}")
    end
  end
         
          
  private  
  
  def expire_all(blog)
    self.class::sweep("blogs/#{blog.id}")
    self.class::sweep("blogs/page")
    expire_page(:controller => '/blogs', :action => 'index')
    expire_page(:controller => '/', :action => 'index')
  end
    
end