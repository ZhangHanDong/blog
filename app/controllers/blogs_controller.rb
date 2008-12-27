class BlogsController < ApplicationController

  caches_page :index

  # GET /blogs
  def index
    respond_to do |format|
      format.html { @blogs = Blog.published.paginate(:page => params[:page], :per_page => 10) }
    end
  end

end