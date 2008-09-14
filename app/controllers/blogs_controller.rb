class BlogsController < ApplicationController

  
  # GET /blogs
  def index
    respond_to do |format|
      format.html {
        @blogs = Blog.published.paginate(:all, :page => params[:page], :per_page => 10)
      }
    end
  end
  

  # GET /blogs/1
  def show
    @blog = Blog.published.find(params[:id])
    redirect_to blog_posts_url(@blog)
  end

end
