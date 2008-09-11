class TagsController < ApplicationController
  
  # GET /blogs/3/tags
  def index              
    @blog = Blog.published.find(params[:blog_id])
    
    if params[:user_id]
      @user = User.find(params[:user_id])
      @collection = @blog.tags.by_user(@user)
    else
      @collection = @blog.tags
    end
    
    respond_to do |format|
      format.html {
        @tags = @collection.paginate(:all, :page => params[:page], :order => 'name ASC', :per_page => 10, :include => :taggings)
      }
    end
  end

end
