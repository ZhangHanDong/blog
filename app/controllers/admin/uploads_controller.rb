class Admin::UploadsController < ApplicationController
  
  layout 'admin'
  before_filter :login_required
  
  # GET /uploads
  # GET /uploads.xml
  def index
    @uploads = Upload.find(:all)
    @upload = Upload.new
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @uploads }
    end
  end

  # GET /uploads/1
  # GET /uploads/1.xml
  def show
    @upload = Upload.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @upload }
    end
  end

  # POST /uploads
  # POST /uploads.xml
  def create
    @upload = Upload.new(params[:upload])

    respond_to do |format|
      if @upload.save
        flash[:notice] = 'Upload was successfully created.'
        format.html { redirect_to(admin_upload_url(@upload)) }
        format.xml  { render :xml => @upload, :status => :created, :location => @upload }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @upload.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /uploads/1
  # DELETE /uploads/1.xml
  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy

    respond_to do |format|
      format.html { redirect_to(admin_uploads_url) }
      format.xml  { head :ok }
    end
  end
end
