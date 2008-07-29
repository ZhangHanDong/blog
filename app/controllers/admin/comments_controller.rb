class Admin::CommentsController < ApplicationController     
  
  layout 'admin'
  before_filter :login_required
  
  
  # GET /admin/posts/1/comments
  # GET /admin/posts/1/comments.xml
  def index
    @post = Post.find(params[:post_id])   
    
    respond_to do |format|
      format.html {
        @comments = @post.comments.paginate(:all, :page => params[:page], :order => 'created_at DESC', :per_page => 10) if @post.comments
      }
      format.xml  { 
        @comments = @post.comments
        render :xml => @comments 
      }
    end
  end  
  
        
  # GET /admin/posts/1/comment/1
  # GET /admin/posts/1/comment/1.xml
  def show         
    @comment = Comment.find(params[:id])  
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @comment }
    end
  end      
  

  # GET /admin/posts/1/comments/new
  # GET /admin/posts/1/comments/new.xml
  def new                       
    @post = Post.find(params[:post_id])     
    @comment = Comment.new                  
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @comment }
    end
  end        
  
  
  # GET /admin/posts/1/comment/1/edit
  def edit       
    @post = Post.find(params[:post_id])  
    @comment = Comment.find(params[:id])
  end           
  

  # POST /admin/posts/1/comments
  # POST /admin/posts/1/comments.xml
  def create                       
    @post = Post.find(params[:post_id])           
    @comment = Comment.new(params[:comment])
    @comment.user = @current_user
    @post.comments << @comment         
    
    respond_to do |format|
      if @post.save
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to(admin_post_comment_path(@post, @comment)) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end 
           
  
  # PUT /admin/posts/1/comment/1
  # PUT /admin/posts/1/comment/1.xml
  def update 
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to(admin_post_comment_path(@post, @comment)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end    
  

  # DELETE /admin/posts/1/comment/1
  # DELETE /admin/posts/1/comment/1.xml
  def destroy                        
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy                              
    
    respond_to do |format|
      format.html { redirect_to(admin_post_comments_url(@post)) }
      format.xml  { head :ok }
    end
  end    
         

end
