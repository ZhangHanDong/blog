class UserSweeper < ActionController::Caching::Sweeper
  
  include SweepingHelper
  
  observe User

  def after_update(user)
    expire_all(user) if user.changed?
  end
  
  def after_destroy(user)
    expire_all(user)
  end
  
  
  private  
  
  def expire_all(user)
    # find all blogs user has posted comments in or posted in
    expire_blogs = user.blogs.concat(Blog.with_comments_by(user)).uniq
    # expire all in each blog
    expire_blogs.each do |blog|
      SweepingHelper::sweep_path("blogs/#{blog.id}")
    end
  end
  
end