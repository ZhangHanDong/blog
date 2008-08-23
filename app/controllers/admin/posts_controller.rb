class Admin::PostsController < ApplicationController
   
  layout 'admin'
  before_filter :login_required
  
  
  # GET /admin/posts
  # GET /admin/posts.xml
  # GET /admin/users/1/posts
  # GET /admin/users/1/posts.xml
  def index 
    if params[:user_id] 
      @user = User.find(params[:user_id])
      conditions = ['user_id = ?', @user.id] if @user
    end
    
    respond_to do |format|
      format.html {
        @posts = Post.paginate(:all, :page => params[:page], :order => 'publish_date DESC', :per_page => 10, :include => [:comments, :user], :conditions => conditions)
      }
      format.xml  { 
        @posts = Post.find(:all, :conditions => conditions)
        render :xml => @posts 
      }
    end
  end
         

  # GET /admin/posts/1
  # GET /admin/posts/1.xml
  def show
    @post = Post.find(params[:id], :include => [:comments, :user])          
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @post }
    end
  end
           

  # GET /admin/posts/new
  # GET /admin/posts/new.xml
  def new
    @post = Post.new                 
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @post }
    end
  end
           

  # GET /admin/posts/1/edit
  def edit
    @post = Post.find(params[:id], :include => [:comments, :user])
  end
            

  # POST /admin/posts
  # POST /admin/posts.xml
  def create
    @post = Post.new(params[:post])
    @post.user = @current_user      
    
    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to(admin_post_url(@post)) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
           

  # PUT /admin/posts/1
  # PUT /admin/posts/1.xml
  def update
    @post = Post.find(params[:id])
    
    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to(admin_post_path(@post)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end               
  

  # DELETE /admin/posts/1
  # DELETE /admin/posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy                     
    
    respond_to do |format|
      format.html { redirect_to(admin_posts_url) }
      format.xml  { head :ok }
    end
  end           
                      
end
