class PostsController < ApplicationController

  caches_page :index, :tagged, :on, :permalink

  # GET /blogs/1/posts
  # GET /blogs/1/posts.atom
  # GET /blogs/1/users/1/posts
  # GET /blogs/1/users/1/posts.atom
  # GET /blogs/1/tags/1/posts
  # GET /blogs/1/tags/1/posts.atom
  def index
    @blog = Blog.published.find(params[:blog_id])

    if params[:user_id]
      @user = User.find(params[:user_id])
      @posts = @blog.posts.published.by_user(@user)
    elsif params[:tag_id]
      @tag = Tag.find(params[:tag_id])
      @posts = @blog.posts.published.with_tag(@tag)
    else
      @posts = @blog.posts.published
    end

    respond_to do |format|
      format.html {
        @posts = @posts.paginate(:all, :page => params[:page], :per_page => 10, :include => [:comments, :user, :tags])
      }
      format.atom {
        @posts = @posts.recent
      }
    end
  end


  # GET /blogs/1/:tag_name
  # GET /blogs/1/:tag_name.atom
  def tagged
    @blog = Blog.published.find(params[:blog_id])
    @posts = Array.new
    
    if params[:tag]                    
      @tag = Tag.find_by_name(params[:tag].humanize.downcase, :limit => 10)
      @posts = @blog.posts.published.with_tag(@tag) if @tag
      if @posts.empty?
        flash[:notice] = "No posts found tagged with \"#{(params[:tag].humanize.downcase)}\""
        redirect_to(blog_posts_url(@blog)) and return
      end
    end

    respond_to do |format|
      format.html { 
        @posts = @posts.paginate(:all, :page => params[:page], :per_page => 10, :include => [:comments, :user, :tags])
      }
      format.atom {
        @posts = @posts.recent
      }
    end                       
    render :action => :index
  end


  # GET /blogs/1/:year/:month/:day
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
  
  
  # GET /blogs/1/:year/:month/:day/:permalink
  def permalink
    @blog = Blog.published.find(params[:blog_id])
    @date_range = Post.get_date_range(params[:year], params[:month], params[:day])
    @post = @blog.posts.published.in_range(@date_range[:start], @date_range[:end]).find_by_permalink(params[:permalink], :include => [:comments, :user, :tags])
    raise ActiveRecord::RecordNotFound unless @post
    @comment = Comment.new

    respond_to do |format|
      format.html { render :action => 'show' }
    end
  end

end
