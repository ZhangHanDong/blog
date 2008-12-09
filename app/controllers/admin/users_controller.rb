class Admin::UsersController < ApplicationController
  
  cache_sweeper :user_sweeper, :only => [:update, :destroy]
  
  layout 'admin', :except => [ :register, :signup ]
  before_filter   :login_required, :except => [ :register, :signup ]
              
      
  # GET /admin/users
  # GET /admin/users.xml 
  # GET /admin/blogs/1/users
  # GET /admin/blogs/1/users.xml
  def index      
    if params[:blog_id]             
      @blog = Blog.find(params[:blog_id])
      @users = @blog.users
    else
      @users = User
    end
    
    respond_to do |format|
      format.html {
        @users = @users.paginate(:all, :page => params[:page], :order => 'created_at DESC', :per_page => 10)
      }
      format.xml { render :xml => @users.recent }
    end
  end
           
  
  # GET /admin/users/1
  # GET /admin/users/1.xml
  def show
    @user = User.find(params[:id])   
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @user }
    end
  end
         
  
  # GET /admin/users/new
  def new
    @user = User.new
  end
         
  
  # GET /users/new
  def signup     
    @user = User.new
    render :action => "signup", :layout => "application"
  end
        
  
  # GET /admin/users/1;edit
  def edit
    @user = User.find(params[:id])
  end
       
   
  # POST /admin/users
  # POST /admin/users.xml           
  def create                       
    @user = User.new(params[:user])    
    
    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to admin_user_url(@user) }
        format.xml  { head :created, :location => admin_user_url(@user) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors.to_xml }
      end
    end
  end
      
 
  # POST /users/register
  def register          
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in           
      flash[:notice] = "Thanks for signing up! You're logged in and ready to go"
      redirect_to(admin_url)
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'signup', :layout => "application"
    end
  end
  
  
  # PUT /admin/users/1
  # PUT /admin/users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to admin_user_url(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors.to_xml }
      end
    end
  end
          

  # DELETE /admin/users/1
  # DELETE /admin/users/1.xml
  def destroy
    @user = User.find(params[:id])
    if @user == @current_user
      flash[:error]  = "Sorry, you cannot delete yourselh while logged in"
      redirect_to admin_users_url
    else
      @user.destroy
      respond_to do |format|
        format.html { redirect_to admin_users_url }
        format.xml  { head :ok }
      end
    end
  end  

end
