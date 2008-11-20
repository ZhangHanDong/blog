class BlogSweeper < ActionController::Caching::Sweeper
  
  observe Blog

  def after_create(blog)
    expire_all
  end
  
  def after_update(blog)
    if blog.in_draft_changed?
      expire_in_draft_changed 
    elsif blog.changed? && !blog.in_draft
      expire_blog_changed(blog)
    end
  end
  
  def after_destroy(post)
    expire_all
  end
  
  def self.sweep(path)
    cache_dir = ActionController::Base.page_cache_directory
    unless cache_dir == RAILS_ROOT+"/public"
      FileUtils.rm_r(Dir.glob(cache_dir+"/#{path}/*")) rescue Errno::ENOENT
      RAILS_DEFAULT_LOGGER.info("Expired blog: path #{path}")
    end
  end
         
          
  private  
  
  def expire_blog_changed(blog)
    RAILS_DEFAULT_LOGGER.info("Expired blog: attributes changed")
    
    if blog.title_changed? 
      all_published = Blog.published.find(:all)
      total_pages = (all_published.length / BlogsController::PER_PAGE.to_f).ceil
      expiry_page = (((all_published.index(blog)+1)/all_published.length) * total_pages.to_f).ceil
      expiry_page = 1 if expiry_page < 1
      expiry_page = total_pages if expiry_page > total_pages
      expire_page(:controller => '/blogs', :action => 'index', :page => expiry_page.to_i) if expiry_page
    end
    
  end
  
  def expire_in_draft_changed
    RAILS_DEFAULT_LOGGER.info("Expired blog: in draft changed")
    expire_all
  end
  
  def expire_all
    self.class::sweep("blogs/page")
    expire_page(:controller => '/blogs', :action => 'index')
    expire_page(:controller => '/', :action => 'index')
  end
    
end