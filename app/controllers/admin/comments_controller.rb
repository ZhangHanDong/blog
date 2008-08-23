class Admin::CommentsController < ApplicationController     
  
  layout 'admin'
  before_filter :login_required
  
  
  # GET /admin/comments
  # GET /admin/comments.xml
  # GET /admin/posts/1/comments
  # GET /admin/posts/1/comments.xml
  # GET /admin/users/1/comments
  # GET /admin/users/1/comments.xml
  def index
    if params[:user_id] 
      @user = User.find(params[:user_id])
      @comments = @user.comments.paginate(:all, :page => params[:page], :order => 'created_at DESC', :per_page => 10, :conditions => ['user_id = ?', @user.id], :include => [:post, :user]) if @user.comments
    elsif params[:post_id] 
      @post = Post.find(params[:post_id])   
      @comments = @post.comments.paginate(:all, :page => params[:page], :order => 'created_at DESC', :per_page => 10, :include => [:post, :user]) if @post.comments
    else
      @comments = Comment.paginate(:all, :page => params[:page], :order => 'created_at DESC', :per_page => 10, :include => [:post, :user])
    end
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @comments }
    end
  end  
  
        
  # GET /admin/posts/1/comment/1
  # GET /admin/posts/1/comment/1.xml
  def show  
    @comment = Comment.find(params[:id], :include => [:post, :user]) 
    @post = @comment.post if @comment
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @comment }
    end
  end      
  

  # GET /admin/posts/1/comments/new
  # GET /admin/posts/1/comments/new.xml
  def new                       
    @post = Post.find(params[:post_id]) if params[:post_id]     
    @comment = Comment.new                  
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @comment }
    end
  end        
  
  
  # GET /admin/posts/1/comment/1/edit
  def edit       
    @comment = Comment.find(params[:id], :include => [:post, :user])
    @post = @comment.post
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
    @comment = Comment.find(params[:id])
    @post = @comment.post
    
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
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @comment.destroy                              
    
    respond_to do |format|
      format.html { redirect_to(admin_post_comments_url(@post)) }
      format.xml  { head :ok }
    end
  end             

end
