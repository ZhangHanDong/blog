require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::UsersController do

  fixtures :users

  before(:each) do
    login_as :quentin
    stub!(:reset_session)
    
    @blog = mock_model(Blog)
    @user = mock_model(User, :destroy => true)
    @users = mock("Array of users", :to_xml => "XML")
    
    Blog.stub!(:find).and_return(@blog)
    User.stub!(:find).and_return(@user)
  end                        
  
  it "should allow access to public signup without login" do
    logout_killing_session! 
    get :signup
    response.should be_success
  end                   
  

  describe "handling GET /users" do

    def do_get
      get :index
    end

    it "should be successful, render index and find all users, assigning for the view" do
      User.should_receive(:paginate).with(:all, {:order=>"created_at DESC", :per_page=>10, :page=>nil}).and_return([@user])
      do_get
      response.should be_success   
      response.should render_template('index')
      assigns[:users].should == [@user]
    end
  end                
  

  describe "handling GET /users.xml" do

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end

    it "should be successful, find all users and render as XML" do
      User.should_receive(:find).with(:all).and_return(@users)
      do_get
      response.body.should == "XML"
      response.should be_success
    end
  end
  
  
  describe "handling GET /blogs/1/users" do

    def do_get
      get :index, :blog_id => "1"
    end

    it "should be successful, render index and find all users, assigning for the view" do
      @blog.should_receive(:users).and_return(@user)
      @user.should_receive(:paginate).with(:all, {:order=>"created_at DESC", :per_page=>10, :page=>nil}).and_return([@user])
      do_get
      response.should be_success   
      response.should render_template('index')
      assigns[:users].should == [@user]
    end
  end

  describe "handling GET /blogs/1/users.xml" do

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index, :blog_id => "1"
    end

    it "should be successful, find all users and render as XML" do
      @blog.should_receive(:users).and_return(@user)
      @user.should_receive(:find).with(:all).and_return(@users)
      do_get
      response.body.should == "XML"
      response.should be_success
    end
  end


  describe "handling GET /users/1" do

    def do_get
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render show template" do
      do_get
      response.should render_template('show')
    end

    it "should find the user requested" do
      User.should_receive(:find).with("1").and_return(@user)
      do_get
    end

    it "should assign the found user for the view" do
      do_get
      assigns[:user].should equal(@user)
    end
  end    
  
  
  describe "handling unsuccessful GET for /admin/users/15155199" do
   
    it "should be redirected with flash message" do
      User.should_receive(:find).and_raise(ActiveRecord::RecordNotFound)
      get :show, :id => "15155199"    
      response.should redirect_to(root_url)
      flash[:notice].should_not be_empty
    end
    
  end
  
  

  describe "handling GET /users/1.xml" do

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find the user requested" do
      User.should_receive(:find).with("1").and_return(@user)
      do_get
    end

    it "should render the found user as xml" do
      @user.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /users/new" do

    def do_get
      User.should_receive(:new).and_return(@user)
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render new template" do
      do_get
      response.should render_template('new')
    end

    it "should create a new user" do
      do_get
    end

    it "should not save the new user" do
      @user.should_not_receive(:save)
      do_get
    end

    it "should assign the new user for the view" do
      do_get
      assigns[:user].should equal(@user)
    end
  end

  describe "handling GET /users/1/edit" do
    
    def do_get
      get :edit, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end

    it "should find the user requested" do
      User.should_receive(:find).and_return(@user)
      do_get
    end

    it "should assign the found User for the view" do
      do_get
      assigns[:user].should equal(@user)
    end
  end

  describe "handling POST /users" do

    describe "with setting author (user)" do

      def do_post
        @user.should_receive(:save).and_return(true)
        post :create, :user => {}
      end

      it "should create a new user with the correct author set" do
        User.should_receive(:new).with({}).and_return(@user)
        do_post
      end

    end

    describe "with successful save" do

      def do_post
        User.should_receive(:new).with({}).and_return(@user)
        @user.should_receive(:save).and_return(true)
        post :create, :user => {}
      end

      it "should create a new user and redirect to the new user" do
        do_post
        response.should redirect_to(admin_user_url(@user))
      end

    end

    describe "with failed save" do

      def do_post
        post :create, :user => {}
      end

      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end

    end
  end

  describe "handling PUT /users/1" do

    describe "with successful update" do

      def do_put
        @user.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the user requested" do
        User.should_receive(:find).with("1").and_return(@user)
        do_put
      end

      it "should update the found user" do
        do_put
        assigns(:user).should equal(@user)
      end

      it "should assign the found user for the view" do
        do_put
        assigns(:user).should equal(@user)
      end

      it "should redirect to the user" do
        do_put
        response.should redirect_to(admin_user_url(@user))
      end

    end

    describe "with failed update" do

      def do_put
        @user.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /users/1" do

    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the user requested" do
      User.should_receive(:find).with("1").and_return(@user)
      do_delete
    end

    it "should call destroy on the found user" do
      @user.should_receive(:destroy)
      do_delete
    end

    it "should redirect to the users list" do
      do_delete
      response.should redirect_to(admin_users_url)
    end
  end


  it 'allows signup' do
    lambda do
      create_user
      response.should be_redirect
    end.should change(User, :count).by(1)
  end

  it 'requires login on signup' do
    lambda do
      create_user(:login => nil)
      assigns[:user].errors.on(:login).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end

  it 'requires password on signup' do
    lambda do
      create_user(:password => nil)
      assigns[:user].errors.on(:password).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end

  it 'requires password confirmation on signup' do
    lambda do
      create_user(:password_confirmation => nil)
      assigns[:user].errors.on(:password_confirmation).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end

  it 'requires email on signup' do
    lambda do
      create_user(:email => nil)
      assigns[:user].errors.on(:email).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end


  def create_user(options = {})
    post :create, :user => { :login => 'quire', :email => 'quire@example.com',
    :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
  end   

  
  describe "User Registration - handling POST /users/register" do
     it 'allows register' do
      lambda do
        register_user
        response.should be_redirect
      end.should change(User, :count).by(1)
    end

    it 'requires login on register' do
      lambda do
        register_user(:login => nil)
        assigns[:user].errors.on(:login).should_not be_nil
        response.should be_success
      end.should_not change(User, :count)
    end

    it 'requires password on register' do
      lambda do
        register_user(:password => nil)
        assigns[:user].errors.on(:password).should_not be_nil
        response.should be_success
      end.should_not change(User, :count)
    end

    it 'requires password confirmation on register' do
      lambda do
        register_user(:password_confirmation => nil)
        assigns[:user].errors.on(:password_confirmation).should_not be_nil
        response.should be_success
      end.should_not change(User, :count)
    end

    it 'requires email on register' do
      lambda do
        register_user(:email => nil)
        assigns[:user].errors.on(:email).should_not be_nil
        response.should be_success
      end.should_not change(User, :count)
    end



    def register_user(options = {})
      post :register, :user => { :login => 'quire', :email => 'quire@example.com',
      :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
    end
  end
  
end      
