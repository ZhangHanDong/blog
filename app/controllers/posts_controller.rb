class PostsController < ApplicationController

  # GET /blog/1/posts
  # GET /blog/1/posts.atom
  # GET /blog/1/users/1/posts
  # GET /blog/1/users/1/posts.atom
  # GET /blog/1/tags/1/posts
  # GET /blog/1/tags/1/posts.atom
  def index
    @blog = Blog.published.find(params[:blog_id])

    if params[:user_id]
      @user = User.find(params[:user_id])
      @collection = @blog.posts.published.by_user(@user)
    elsif params[:tag_id]
      @tag = Tag.find(params[:tag_id])
      @collection = @blog.posts.published.with_tag(@tag)
    else
      @collection = @blog.posts.published
    end

    respond_to do |format|
      format.html {
        @posts = @collection.paginate(:all, :page => params[:page], :per_page => 10, :include => [:comments, :user, :tags])
      }
      format.atom {
        @posts = @collection.recent.find(:all)
      }
    end
  end


  # GET /blog/1/on/:year/:month/:day
  def on
    @blog = Blog.published.find(params[:blog_id])
    @date_range = Post.get_date_range(params[:year], params[:month], params[:day])
    @posts = @blog.posts.published.in_range(@date_range[:start], @date_range[:end]).paginate(:all, :page => params[:page], :per_page => 10, :include => [:comments, :user, :tags])

    respond_to do |format|
      format.html {
        if @posts.empty?
          flash[:notice] = "No posts found #{@date_range[:descriptor]}"
          redirect_to(blog_posts_url(@blog))
        else
          render :action => 'index'
        end
      }
    end
  end


  # GET /blog/1/posts/1
  def show
    @blog = Blog.published.find(params[:blog_id])
    @post = @blog.posts.published.find(params[:id], :include => [:comments, :user, :tags])
    @comment = Comment.new

    respond_to do |format|
      format.html
    end
  end

end
