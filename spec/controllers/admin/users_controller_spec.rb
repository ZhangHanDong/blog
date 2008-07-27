require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::UsersController do

  fixtures :users

  before(:each) do
    login_as :quentin
    stub!(:reset_session)
  end                        
  
  it "should allow access to public signup without login" do
    logout_killing_session! 
    get :signup
    response.should be_success
  end

  describe "handling GET /users" do

    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @user = mock_model(User)
      User.stub!(:find).and_return([@user])
    end

    def do_get
      get :index
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end

    it "should find all users" do
      User.should_receive(:find).with(:all, {:offset=>0, :limit=>10, :order=>"created_at DESC"}).and_return([@user])
      do_get
    end

    it "should assign the found users for the view" do
      do_get
      assigns[:users].should == [@user]
    end
  end

  describe "handling GET /users.xml" do

    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @users = mock("Array of users", :to_xml => "XML")
      User.stub!(:find).and_return(@users)
    end

    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all users" do
      User.should_receive(:find).with(:all).and_return(@users)
      do_get
    end

    it "should render the found users as xml" do
      @users.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end


  describe "handling GET /users/1" do

    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @user = mock_model(User)
      User.stub!(:find).and_return(@user)
    end

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
    before(:each) do
      login_as :quentin
      stub!(:reset_session)
    end

    it "should be redirected with flash message" do
      get :show, :id => "15155199"    
      response.should redirect_to(root_url)
      flash[:notice].should_not be_empty
    end
  end
  
  

  describe "handling GET /users/1.xml" do

    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @user = mock_model(User, :to_xml => "XML")
      User.stub!(:find).and_return(@user)
    end

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

    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @user = mock_model(User)
      User.stub!(:new).and_return(@user)
    end

    def do_get
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

    it "should create an new user" do
      User.should_receive(:new).and_return(@user)
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

    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @user = mock_model(User)
      User.stub!(:find).and_return(@user)
    end

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

    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @user = mock_model(User, :to_param => "1")
      User.stub!(:new).and_return(@user)

    end

    describe "with setting author (user)" do

      def do_post
        @user.should_receive(:save).and_return(true)
        post :create, :user => {}
      end

      it "should create a new user with the correct author set" do
        User.should_receive(:new).with({}).and_return(@user)
        login_as :aaron
        do_post
      end

    end

    describe "with successful save" do

      def do_post
        @user.should_receive(:save).and_return(true)
        post :create, :user => {}
      end

      it "should create a new user" do
        User.should_receive(:new).with({}).and_return(@user)
        do_post
      end

      it "should redirect to the new user" do
        do_post
        response.should redirect_to(admin_user_url("1"))
      end

    end

    describe "with failed save" do

      def do_post
        @user.should_receive(:save).and_return(false)
        post :create, :user => {}
      end

      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end

    end
  end

  describe "handling PUT /users/1" do

    before(:each) do
      login_as :quentin
      stub!(:reset_session)
      @user = mock_model(User, :to_param => "1")
      User.stub!(:find).and_return(@user)
    end

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
        response.should redirect_to(admin_user_url("1"))
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
      login_as :quentin
      stub!(:reset_session)
      @user = mock_model(User, :destroy => true)
      User.stub!(:find).and_return(@user)
    end

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
  




        




describe Admin::UsersController do
  describe "route generation" do      
    
    it "should route to user signup correctly" do
      route_for(:controller => 'admin/users', :action => 'signup').should == "/signup"
    end
    
    it "should route to user register correctly" do
      route_for(:controller => 'admin/users', :action => 'register').should == "/admin/users/register"
    end
    
    it "should route users's 'index' action correctly" do
      route_for(:controller => 'admin/users', :action => 'index').should == "/admin/users"
    end

    it "should route users's 'new' action correctly" do
      route_for(:controller => 'admin/users', :action => 'new').should == "/admin/users/new"
    end

    it "should route {:controller => 'admin/users', :action => 'create'} correctly" do
      route_for(:controller => 'admin/users', :action => 'create').should == "/admin/users"
    end

    it "should route users's 'show' action correctly" do
      route_for(:controller => 'admin/users', :action => 'show', :id => '1').should == "/admin/users/1"
    end

    it "should route users's 'edit' action correctly" do
      route_for(:controller => 'admin/users', :action => 'edit', :id => '1').should == "/admin/users/1/edit"
    end

    it "should route users's 'update' action correctly" do
      route_for(:controller => 'admin/users', :action => 'update', :id => '1').should == "/admin/users/1"
    end

    it "should route users's 'destroy' action correctly" do
      route_for(:controller => 'admin/users', :action => 'destroy', :id => '1').should == "/admin/users/1"
    end
  end

  describe "route recognition" do
    it "should generate params for users's index action from GET /users" do
      params_from(:get, '/admin/users').should == {:controller => 'admin/users', :action => 'index'}
      params_from(:get, '/admin/users.xml').should == {:controller => 'admin/users', :action => 'index', :format => 'xml'}
      params_from(:get, '/admin/users.json').should == {:controller => 'admin/users', :action => 'index', :format => 'json'}
    end

    it "should generate params for users's new action from GET /users" do
      params_from(:get, '/admin/users/new').should == {:controller => 'admin/users', :action => 'new'}
      params_from(:get, '/admin/users/new.xml').should == {:controller => 'admin/users', :action => 'new', :format => 'xml'}
      params_from(:get, '/admin/users/new.json').should == {:controller => 'admin/users', :action => 'new', :format => 'json'}
    end
    
    it "should generate params for users's new action from GET /users" do
      params_from(:get, '/signup').should == {:controller => 'admin/users', :action => 'signup'}
    end

    it "should generate params for users's create action from POST /users" do
      params_from(:post, '/admin/users').should == {:controller => 'admin/users', :action => 'create'}
      params_from(:post, '/admin/users.xml').should == {:controller => 'admin/users', :action => 'create', :format => 'xml'}
      params_from(:post, '/admin/users.json').should == {:controller => 'admin/users', :action => 'create', :format => 'json'}
    end
    
    it "should generate params for users's create action from POST /users" do
      params_from(:post, '/admin/users/register').should == {:controller => 'admin/users', :action => 'register'}
    end

    it "should generate params for users's show action from GET /users/1" do
      params_from(:get , '/admin/users/1').should == {:controller => 'admin/users', :action => 'show', :id => '1'}
      params_from(:get , '/admin/users/1.xml').should == {:controller => 'admin/users', :action => 'show', :id => '1', :format => 'xml'}
      params_from(:get , '/admin/users/1.json').should == {:controller => 'admin/users', :action => 'show', :id => '1', :format => 'json'}
    end

    it "should generate params for users's edit action from GET /users/1/edit" do
      params_from(:get , '/admin/users/1/edit').should == {:controller => 'admin/users', :action => 'edit', :id => '1'}
    end

    it "should generate params {:controller => 'admin/users', :action => update', :id => '1'} from PUT /users/1" do
      params_from(:put , '/admin/users/1').should == {:controller => 'admin/users', :action => 'update', :id => '1'}
      params_from(:put , '/admin/users/1.xml').should == {:controller => 'admin/users', :action => 'update', :id => '1', :format => 'xml'}
      params_from(:put , '/admin/users/1.json').should == {:controller => 'admin/users', :action => 'update', :id => '1', :format => 'json'}
    end

    it "should generate params for users's destroy action from DELETE /users/1" do
      params_from(:delete, '/admin/users/1').should == {:controller => 'admin/users', :action => 'destroy', :id => '1'}
      params_from(:delete, '/admin/users/1.xml').should == {:controller => 'admin/users', :action => 'destroy', :id => '1', :format => 'xml'}
      params_from(:delete, '/admin/users/1.json').should == {:controller => 'admin/users', :action => 'destroy', :id => '1', :format => 'json'}
    end
  end

  describe "named routing" do
    before(:each) do
      get :new
    end

    it "should route admin_users_path() to /admin/users" do
      admin_users_path().should == "/admin/users"
      formatted_admin_users_path(:format => 'xml').should == "/admin/users.xml"
      formatted_admin_users_path(:format => 'json').should == "/admin/users.json"
    end

    it "should route new_user_path() to /admin/users/new" do
      new_admin_user_path().should == "/admin/users/new"
      formatted_new_admin_user_path(:format => 'xml').should == "/admin/users/new.xml"
      formatted_new_admin_user_path(:format => 'json').should == "/admin/users/new.json"
    end

    it "should route user_(:id => '1') to /users/1" do
      admin_user_path(:id => '1').should == "/admin/users/1"
      formatted_admin_user_path(:id => '1', :format => 'xml').should == "/admin/users/1.xml"
      formatted_admin_user_path(:id => '1', :format => 'json').should == "/admin/users/1.json"
    end

    it "should route edit_user_path(:id => '1') to /admin/users/1/edit" do
      edit_admin_user_path(:id => '1').should == "/admin/users/1/edit"
    end
  end

end
