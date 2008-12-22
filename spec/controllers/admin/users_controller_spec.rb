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
      @user.should_receive(:paginate).with({:order=>"created_at DESC",
                                            :per_page=>10, :page=>nil}).and_return([@user])
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
      @users.should_receive(:recent).and_return(@users)
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
      @user.should_receive(:paginate).with({:order=>"created_at DESC",
                                            :per_page=>10, :page=>nil}).and_return([@user])
      do_get
      response.should be_success
      response.should render_template('index')
      assigns[:users].should == [@user]
    end

  end


  describe "handling GET /users/1" do

    def do_get
      get :show, :id => "1"
    end

    it "should be successful, render show template and find the user requested and assign" do
      User.should_receive(:find).with("1").and_return(@user)
      do_get
      response.should be_success
      response.should render_template('show')
      assigns[:user].should equal(@user)
    end

  end


  describe "handling GET /users/1.xml" do

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful, find the user requested and render as XML" do
      User.should_receive(:find).with("1").and_return(@user)
      @user.should_receive(:to_xml).and_return("XML")
      do_get
      response.should be_success
      response.body.should == "XML"
    end

  end


  describe "handling GET /users/new" do

    def do_get
      User.should_receive(:new).and_return(@user)
      get :new
    end

    it "should be successful, render new, create new user (not save) and assign view" do
      @user.should_not_receive(:save)
      do_get
      response.should be_success
      response.should render_template('new')
      assigns[:user].should equal(@user)
    end

  end


  describe "handling GET /users/1/edit" do

    def do_get
      get :edit, :id => "1"
    end

    it "should be successful, render edit, find user and assign in view" do
      User.should_receive(:find).and_return(@user)
      do_get
      response.should be_success
      response.should render_template('edit')
      assigns[:user].should equal(@user)
    end

  end


  describe "handling POST /users" do

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

      it "should find the user requested, update and redirect to user" do
        User.should_receive(:find).with("1").and_return(@user)
        do_put
        assigns(:user).should equal(@user)
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

    before(:each) do
      #fake the contoller to think a different user logged in
      controller.stub!(:current_user).and_return(users(:quentin))
    end

    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the user requested, call destroy and redirect to listing" do
      User.should_receive(:find).with("1")
      @user.should_receive(:destroy)
      do_delete
      response.should redirect_to(admin_users_url)
    end

  end


  describe "handling failed DELETE /users/1 - cannot delete yourself if logged in user" do

    def do_delete
      delete :destroy, :id => "1"
    end

    it "should not call destroy on the found user, show error and redirect" do
      User.stub!(:find).and_return(@user)
      # user and current_user match
      User.should_receive(:find).with("1")
      @user.should_not_receive(:destroy)
      do_delete
      flash[:error].should_not be_empty
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
  
  
  describe "handling exceptions" do

    before(:each) do
      controller.use_rails_error_handling!
    end

    it "should render 404 for RecordNotFound on GET /admin/users/15155199 " do
      User.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
      get :show, :id => "15155199"
      response.should render_template("#{RAILS_ROOT}/public/404.html")
    end
    
  end

end