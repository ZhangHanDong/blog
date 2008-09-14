class Admin::TagsController < ApplicationController
  
  layout 'admin'
  before_filter :login_required
        
  
  # GET /admin/blogs/3/tags
  # GET /admin/blogs/3/tags.xml
  # GET /admin/blogs/3/users/1/tags
  # GET /admin/blogs/3/users/1/tags.xml
  def index    
    @blog = Blog.find(params[:blog_id])
    
    if params[:user_id]
      @user = User.find(params[:user_id])
      @tags = @blog.tags.by_user(@user)
    else
      @tags = @blog.tags
    end
    
    respond_to do |format|
      format.html {
        @tags = @tags.paginate(:all, :page => params[:page], :order => 'name ASC', :per_page => 10, :include => :taggings)
      }
      format.xml { render :xml => @tags.recent }
    end
  end
         

  # GET /admin/blogs/3/tag/1
  # GET /admin/blogs/3/tag/1.xml
  def show    
    @blog = Blog.find(params[:blog_id])
    conditions = ['taggings.blog_id = ?', @blog.id] if @blog
    @tag = Tag.find(params[:id], :include => :taggings, :conditions => conditions)          

    respond_to do |format|
      format.html
      format.xml { render :xml => @tag }
    end
  end 
   
end
