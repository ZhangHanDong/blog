class Admin::PostsController < ApplicationController
   
  layout 'admin'
  before_filter :login_required
                      
  
  # GET /admin/users/1/posts
  # GET /admin/users/1/posts.xml  
  # GET /admin/blogs/1/posts
  # GET /admin/blogs/1/posts.xml
  # GET /admin/blogs/1/tags/1/posts
  # GET /admin/blogs/1/tags/1/posts.xml
  # GET /admin/blogs/1/users/1/posts
  # GET /admin/blogs/1/users/1/posts.xml
  def index      
    if params[:blog_id]
      @blog = Blog.find(params[:blog_id])            
      if params[:user_id] 
        @user = User.find(params[:user_id])
        @posts = @blog.posts.by_user(@user)
      elsif params[:tag_id]
        @tag = Tag.find(params[:tag_id])
        @posts = @blog.posts.with_tag(@tag)
      else  
        @posts = @blog.posts
      end  
    elsif params[:user_id] 
      @user = User.find(params[:user_id])
      @posts = @user.posts
    end
        
    respond_to do |format|
      format.html {
        @posts = @posts.paginate(:all, :page => params[:page], :per_page => 10, :include => [:blog, :comments, :user, :tags])
      }
      format.xml { render :xml => @posts.recent }
    end
  end
         

  # GET /admin/blogs/1/posts/1
  # GET /admin/blogs/1/posts/1.xml
  def show 
    @post = Post.find(params[:id], :include => [:blog, :comments, :user, :tags])          
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @post }
    end
  end
           

  # GET /admin/blogs/1/posts/new
  # GET /admin/blogs/1posts/new.xml
  def new  
    @blog = Blog.find(params[:blog_id])
    @post = Post.new                 
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @post }
    end
  end
           

  # GET /admin/blogs/1/posts/1/edit
  def edit       
    @post = Post.find(params[:id], :include => [:blog, :comments, :user, :tags])
  end
            

  # POST /admin/blogs/1/posts
  # POST /admin/blogs/1/posts.xml
  def create    
    @blog = Blog.find(params[:blog_id])
    @post = Post.new(params[:post])
    @post.user = @current_user      
    @blog.posts << @post
       
    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to(admin_blog_post_url(@blog, @post)) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
           

  # PUT /admin/blogs/1/posts/1
  # PUT /admin/blogs/1/posts/1.xml
  def update
    @post = Post.find(params[:id], :include => :blog)
    
    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to(admin_blog_post_url(@post.blog, @post)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end               
  

  # DELETE /admin/blogs/1/posts/1
  # DELETE /admin/blogs/1/posts/1.xml
  def destroy
    @post = Post.find(params[:id], :include => :blog)
    @post.destroy                     
    
    respond_to do |format|
      format.html { redirect_to(admin_blog_posts_url(@post.blog)) }
      format.xml  { head :ok }
    end
  end           
                      
end
