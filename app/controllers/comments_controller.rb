class CommentsController < ApplicationController
              
  cache_sweeper :comment_sweeper, :only => [:create]
  
  caches_page :index

  # GET blogs/1/comments
  # GET blogs/1/comments.atom
  # GET blogs/1/posts/1/comments
  # GET blogs/1/posts/1/comments.atom
  # GET blogs/1/users/2/comments
  # GET blogs/1/users/2/comments.atom
  def index
    @blog = Blog.published.find(params[:blog_id])

    if params[:post_id]
      @post = @blog.posts.published.find(params[:post_id])
      @comments = @post.comments
    elsif params[:user_id]
      @user = User.find(params[:user_id])
      @comments = @blog.comments.published.by_user(@user)
    elsif params[:blog_id]
      @comments = @blog.comments.published
    end

    respond_to do |format|
      format.html {
        @comments = @comments.paginate(:all, :page => params[:page], :per_page => 10, :include => :post)
      }
      format.atom {
        @comments = @comments.recent
      }
    end
  end


  # GET  blogs/1/posts/1/comments/1
  def show
    @comment = Comment.published.find(params[:id], :include => {:post => :blog})
    redirect_to url_for(@comment.post.permalink_url({:anchor => "comment-#{@comment.id}"}))
  end


  # POST blogs/1/posts/1/comments
  def create
    @post = Post.published.find(params[:post_id], :include => :blog)
    @comment = Comment.new(params[:comment])
    @comment.post = @post
    @comment.user = current_user if current_user

    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to url_for(@post.permalink_url) }
      else
        format.html { render :action => "new" }
      end
    end
  end

end
