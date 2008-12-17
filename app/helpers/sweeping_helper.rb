module SweepingHelper

  # sweep (delete) the contents of a directory in the public cache
  def self.sweep_path(path)
    cache_dir = ActionController::Base.page_cache_directory
    unless cache_dir == RAILS_ROOT+"/public"
      FileUtils.rm_r(Dir.glob(cache_dir+"/#{path}/*")) rescue Errno::ENOENT
      RAILS_DEFAULT_LOGGER.info("Expired path: #{path}")
    end
  end

end