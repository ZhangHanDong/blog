class BlogsController < ApplicationController

  caches_page :index


  # GET /blogs
  def index
    respond_to do |format|
      format.html { @blogs = Blog.published.paginate(:page => params[:page], :per_page => 10) }
    end
  end


  # GET /blogs/1
  def show
    @blog = Blog.published.find(params[:id])
    redirect_to blog_posts_url(@blog)
  end

end
