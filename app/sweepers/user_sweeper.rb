class UserSweeper < ActionController::Caching::Sweeper
  
  include SweepingHelper
  
  observe User

  def after_update(user)
    expire_all(user) if user.name_changed? || user.email_changed?
  end
  
  def after_destroy(user)
    expire_all(user)
  end
  
  
  private  
  
  def expire_all(user)
    # find all blogs user has posted comments in or blog posted in
    commented_blogs = Blog.with_comments_by(user) || []
    expire_blogs = commented_blogs.concat(user.blogs).uniq
     
    # expire all in each blog
    expire_blogs.each do |blog|
      SweepingHelper::sweep_path("blogs/#{blog.id}")
    end
  end
  
end