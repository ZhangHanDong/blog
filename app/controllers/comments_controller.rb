class CommentsController < ApplicationController

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
      @collection = @post.comments
    elsif params[:user_id]
      @user = User.find(params[:user_id])
      @collection = @blog.comments.published.by_user(@user)
    elsif params[:blog_id]
      @collection = @blog.comments.published
    end

    respond_to do |format|
      format.html {
        @comments = @collection.paginate(:all, :page => params[:page], :per_page => 10, :include => :post)
      }
      format.atom {
        @comments = @collection.recent.find(:all)
      }
    end
  end


  # GET  blogs/1/posts/1/comments/1
  def show
    @comment = Comment.published.find(params[:id], :include => {:post => :blog})
    redirect_to blog_post_path(@comment.post.blog, @comment.post, :anchor => "comment-#{@comment.id}")
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
        format.html { redirect_to(blog_post_path(@post.blog, @post)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

end
