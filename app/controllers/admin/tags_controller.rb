class Admin::TagsController < ApplicationController
  
  layout 'admin'
  before_filter :login_required
        
  
  # GET /admin/tags
  # GET /admin/tags.xml
  def index
    respond_to do |format|
      format.html {
        @tags = Tag.paginate(:all, :page => params[:page], :order => 'name ASC', :per_page => 10)
      }
      format.xml  { 
        @tags = Tag.find(:all)
        render :xml => @tags 
      }
    end
  end
         

  # GET /admin/tag/1
  # GET /admin/tag/1.xml
  def show
    @tag = Tag.find(params[:id], :include => {:taggings => [:user, :taggable]})          

    respond_to do |format|
      format.html
      format.xml  { render :xml => @tag }
    end
  end 
      
      
end
