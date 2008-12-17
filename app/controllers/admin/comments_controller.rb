class Admin::CommentsController < ApplicationController

  cache_sweeper :comment_sweeper, :only => [:create, :update, :destroy]

  layout 'admin'
  before_filter :login_required
  

  # GET /admin/users/1/comments
  # GET /admin/users/1/comments.xml
  # GET /admin/blogs/1/comments
  # GET /admin/blogs/1/comments.xml
  # GET /admin/blogs/1/posts/1/comments
  # GET /admin/blogs/1/posts/1/comments.xml
  # GET /admin/blogs/1/users/1/comments
  # GET /admin/blogs/1/users/1/comments.xml
  def index
    if params[:blog_id]
      @blog = Blog.find(params[:blog_id])
      if params[:user_id]
        @user = User.find(params[:user_id])
        @comments = @blog.comments.by_user(@user)
      elsif params[:post_id]
        @post = @blog.posts.find(params[:post_id])
        @comments = @post.comments
      elsif @blog
        @comments = @blog.comments
      end
    elsif params[:user_id]
      @user = User.find(params[:user_id])
      @comments = @user.comments
    end

    respond_to do |format|
      format.html {
        @comments = @comments.paginate(:page => params[:page], :per_page => 10,
                                       :include => { :post => :blog })
      }
      format.xml { render :xml => @comments.recent }
    end
  end

  # GET /admin/blogs/1/posts/1/comment/1
  # GET /admin/blogs/1/posts/1/comment/1.xml
  def show
    @comment = Comment.find(params[:id], :include => [:post, :user])

    respond_to do |format|
      format.html
      format.xml { render :xml => @comment }
    end
  end

  # GET /admin/blogs/1/posts/1/comments/new
  # GET /admin/blogs/1/posts/1/comments/new.xml
  def new
    @post = Post.find(params[:post_id], :include => :blog)
    @comment = Comment.new

    respond_to do |format|
      format.html
      format.xml { render :xml => @comment }
    end
  end

  # GET /admin/blogs/1/posts/1/comment/1/edit
  def edit
    @comment = Comment.find(params[:id], :include => [:post, :user])
  end

  # POST /admin/blogs/1/posts/1/comments
  # POST /admin/blogs/1/posts/1/comments.xml
  def create
    @post = Post.find(params[:post_id], :include => :blog)
    @comment = Comment.new(params[:comment])
    @comment.user = @current_user
    @post.comments << @comment

    respond_to do |format|
      if @post.save
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to(admin_blog_post_comment_url(@post.blog, @post, @comment)) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/blogs/1/posts/1/comment/1
  # PUT /admin/blogs/1/posts/1/comment/1.xml
  def update
    @comment = Comment.find(params[:id], :include => :post)

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to(admin_blog_post_comment_url(@comment.post.blog,
                                                              @comment.post, @comment)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/blogs/1/posts/1/comment/1
  # DELETE /admin/blogs/1/posts/1/comment/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(admin_blog_post_comments_url(@comment.post.blog, @comment.post)) }
      format.xml  { head :ok }
    end
  end

end