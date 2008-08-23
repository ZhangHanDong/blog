class Admin::BlogsController < ApplicationController
  
  layout 'admin'
  before_filter :login_required
             
    
  # GET /admin/blogs
  # GET /admin/blogs.xml
  # GET /admin/users/1/blogs
  # GET /admin/users/1/blogs.xml
  def index
    if params[:user_id] 
      @user = User.find(params[:user_id])
      conditions = ['created_by_id = ?', @user.id] if @user
    end 
    
    respond_to do |format|
      format.html {   
        @blogs = Blog.paginate(:all, :page => params[:page], :per_page => 10, :conditions => conditions, :include => :creator)
      }
      format.xml  { 
        @blogs = Blog.find(:all, :conditions => conditions, :include => :creator)
        render :xml => @blogs
      }
    end
  end
        

  # GET /admin/blogs/1
  # GET /admin/blogs/1.xml
  def show
    @blog = Blog.find(params[:id], :include => :creator)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @blog }
    end
  end
         

  # GET /admin/blogs/new
  # GET /admin/blogs/new.xml
  def new
    @blog = Blog.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @blog }
    end
  end
          

  # GET /admin/blogs/1/edit
  def edit
    @blog = Blog.find(params[:id], :include => :creator)
  end
         

  # POST /admin/blogs
  # POST /admin/blogs.xml
  def create
    @blog = Blog.new(params[:blog])
    @blog.creator = @current_user

    respond_to do |format|
      if @blog.save
        flash[:notice] = 'Blog was successfully created.'
        format.html { redirect_to(admin_blog_path(@blog)) }
        format.xml  { render :xml => @blog, :status => :created, :location => @blog }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end
          

  # PUT /admin/blogs/1
  # PUT /admin/blogs/1.xml
  def update
    @blog = Blog.find(params[:id])

    respond_to do |format|
      if @blog.update_attributes(params[:blog])
        flash[:notice] = 'Blog was successfully updated.'
        format.html { redirect_to(admin_blog_path(@blog)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end
          

  # DELETE /admin/blogs/1
  # DELETE /admin/blogs/1.xml
  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy

    respond_to do |format|
      format.html { redirect_to(admin_blogs_url) }
      format.xml  { head :ok }
    end
  end 
  
end
