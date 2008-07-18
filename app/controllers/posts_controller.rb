class PostsController < ApplicationController

  # GET /posts
  # GET /posts.atom
  # GET /users/:id/posts
  # GET /users/:id/posts.atom
  def index                           
    if params[:user_id] 
      @user = User.find(params[:user_id])
      conditions = ['user_id = ?', @user.id] if @user
    end
    respond_to do |format|
      format.html {                                                                                                           
        @posts = Post.published.paginate(:all, :page => params[:page], :per_page => 10, :include => [:comments, :user, :tags], :conditions => conditions)
      }
      format.atom {
        @posts = Post.published.recent.find(:all, :include => [:comments, :user], :conditions => conditions)
      }
    end
  end


  # GET /posts/:year/:month/:day
  def date
    @date_range = Post.get_date_range(params[:year], params[:month], params[:day])
    @posts = Post.published.in_range(@date_range[:start], @date_range[:end]).paginate(:all, :page => params[:page], :per_page => 10, :include => [:comments, :user, :tags])
    respond_to do |format|
      format.html {
        if @posts.empty?
          flash[:notice] = 'No posts found on that day or dates'
          redirect_to(posts_url)
        else
          render :action => 'index'
        end
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
