class BlogsController < ApplicationController

  caches_page :index

  PER_PAGE = 2

  # GET /blogs
  def index
    respond_to do |format|
      format.html {
        @blogs = Blog.published.paginate(:all, :page => params[:page], :per_page => BlogsController::PER_PAGE)
      }
    end
  end
  

  # GET /blogs/1
  def show
    @blog = Blog.published.find(params[:id])
    redirect_to blog_posts_url(@blog)
  end

end
