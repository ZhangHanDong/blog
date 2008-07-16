class PostsController < ApplicationController
  
  # GET /posts
  # GET /posts.atom
  def index
    respond_to do |format|
      format.html {
        @posts = Post.published.paginate(:all, :page => params[:page], :per_page => 10, :include => [:comments, :user, :tags])
      }                  
      format.atom {
        @posts = Post.published.recent.find(:all, :include => [:comments, :user])  
      }
    end
  end
      

  # GET /posts/1
  def show
    @post = Post.published.find(params[:id], :include => [:comments, :user, :tags])          
    @comment = Comment.new
    respond_to do |format|
      format.html             
    end
  end   
  

end
