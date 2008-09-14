class UsersController < ApplicationController
              
  
  # GET /blogs/1/users
  def index
    @blog = Blog.published.find(params[:blog_id])
    
    respond_to do |format|
      format.html {
        @users = @blog.users.paginate(:all, :page => params[:page], :order => 'created_at DESC', :per_page => 10)
      }
    end
  end
        
  
  # GET /blogs/1/users/1
  def show    
    @blog = Blog.published.find(params[:blog_id])          
    @user = @blog.users.find(params[:id])
    @posts = @blog.posts.published.by_user(@user)
    @comments = @blog.comments.published.by_user(@user)
  end

end
