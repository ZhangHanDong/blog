class CommentsController < ApplicationController
  
  # GET /posts/1/comments.atom
  def index
    @post = Post.published.find(params[:post_id], :include => [:comments, :user])
    respond_to do |format|
      format.atom #index.atom.builder
    end
  end
  
  
  # POST /posts/1/comments
  def create
    @post = Post.published.find(params[:post_id])           
    @comment = Comment.new(params[:comment])
    @comment.post = @post

    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to(post_path(@post)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

end
