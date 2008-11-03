class Admin::UploadsController < ApplicationController
  
  layout 'admin'
  before_filter :login_required


  # GET /admin/blogs/1/uploads
  # GET /admin/blogs/1/uploads.xml
  # GET /admin/blogs/1/users/1/uploads
  # GET /admin/blogs/1/users/1/uploads.xml
  def index
    @upload = Upload.new
    
    @blog = Blog.find(params[:blog_id])
    if params[:user_id] 
      @user = User.find(params[:user_id])
      @uploads = @blog.uploads.by_user(@user)
    else
      @uploads = @blog.uploads
    end
    
    respond_to do |format|
      format.html {
        @uploads = @uploads.paginate(:page => params[:page], :per_page => 12, :include => [:blog, :user])
      }
      format.xml { render :xml => @uploads.recent }
    end
    
  end


  # GET /admin/blogs/1/uploads/1
  # GET /admin/blogs/1/uploads/1.xml
  def show
    @blog = Blog.find(params[:blog_id])
    @upload = @blog.uploads.find(params[:id], :include => [:blog, :user])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @upload }
    end
  end


  # POST /admin/blogs/1/uploads
  # POST /admin/blogs/1/uploads.xml
  def create
    @blog = Blog.find(params[:blog_id])
    @upload = Upload.new(params[:upload])
    @upload.user = @current_user      
    @blog.uploads << @upload

    respond_to do |format|
      if @upload.save
        flash[:notice] = 'Upload was successfully created.'
        format.html { redirect_to(admin_blog_uploads_url(@blog)) }
        format.xml  { render :xml => @upload, :status => :created, :location => @upload }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @upload.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /admin/blogs/1/uploads/1
  # DELETE /admin/blogs/1/uploads/1.xml
  def destroy
    @upload = Upload.find(params[:id], :include => :blog)
    @upload.destroy

    respond_to do |format|
      format.html { redirect_to(admin_blog_uploads_url(@upload.blog)) }
      format.xml  { head :ok }
    end
  end
  
  
end
