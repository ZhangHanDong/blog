class TagsController < ApplicationController

  caches_page :index


  # GET /blogs/1/tags
  # GET /blogs/1/users/1/tags
  def index
    @blog = Blog.published.find(params[:blog_id])
    if params[:user_id]
      @user = User.find(params[:user_id])
      @tags = @blog.tags.by_user(@user)
    elsif @blog
      @tags = @blog.tags.find(:all, :limit => 50)
    end
  end

end
