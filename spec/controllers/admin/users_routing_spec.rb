require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::UsersController do
  
  describe "route generation" do

    it "should map { :controller => 'admin/users', :action => 'signup' } to /signup" do
      route_for(:controller => "admin/users", :action => "signup").should == "/signup"
    end

    it "should map { :controller => 'admin/users', :action => 'index' } to /admin/users" do
      route_for(:controller => "admin/users", :action => "index").should == "/admin/users"
    end
    
    it "should map { :controller => 'admin/users', :action => 'index', :blog_id => '1' } to /admin/blogs/1/users" do
      route_for(:controller => "admin/users", :action => "index", :blog_id => "1").should == "/admin/blogs/1/users"
    end

    it "should map { :controller => 'admin/users', :action => 'index' } to /admin/users" do
      route_for(:controller => "admin/users", :action => "index").should == "/admin/users"
    end

    it "should map { :controller => 'admin/users', :action => 'new' } to /admin/users/new" do
      route_for(:controller => "admin/users", :action => "new").should == "/admin/users/new"
    end

    it "should map { :controller => 'admin/users', :action => 'show', :id => '1' } to /admin/users/1" do
      route_for(:controller => "admin/users", :action => "show", :id => "1").should == "/admin/users/1"
    end

    it "should map { :controller => 'admin/users', :action => 'edit', :id => '1' } to /admin/users/1/edit" do
      route_for(:controller => "admin/users", :action => "edit", :id => "1").should == "/admin/users/1/edit"
    end

    it "should map { :controller => 'admin/users', :action => 'update', :id => '1'} to /admin/users/1" do
      route_for(:controller => "admin/users", :action => "update", :id => "1").should == "/admin/users/1"
    end

    it "should map { :controller => 'admin/users', :action => 'destroy', :id => '1'} to /admin/users/1" do
      route_for(:controller => "admin/users", :action => "destroy", :id => "1").should == "/admin/users/1"
    end
  end
  

  describe "route recognition" do
    
    it "should generate params { :controller => 'admin/users', action => 'signup' } from GET /signup" do
      params_from(:get, "/signup").should == {:controller => "admin/users", :action => "signup"}
    end

    it "should generate params { :controller => 'admin/users', action => 'index' } from GET /admin/users" do
      params_from(:get, "/admin/users").should == {:controller => "admin/users", :action => "index"}
    end 
    
    it "should generate params { :controller => 'admin/users', action => 'index', :blog_id => '1' } from GET /admin/blogs/1/users" do
      params_from(:get, "/admin/blogs/1/users").should == {:controller => "admin/users", :action => "index", :blog_id => "1"}
    end

    it "should generate params { :controller => 'admin/users', action => 'new' } from GET /admin/users/new" do
      params_from(:get, "/admin/users/new").should == {:controller => "admin/users", :action => "new"}
    end

    it "should generate params { :controller => 'admin/users', action => 'create' } from POST /admin/users" do
      params_from(:post, "/admin/users").should == {:controller => "admin/users", :action => "create"}
    end

    it "should generate params { :controller => 'admin/users', action => 'show', id => '1' } from GET /admin/users/1" do
      params_from(:get, "/admin/users/1").should == {:controller => "admin/users", :action => "show", :id => "1"}
    end

    it "should generate params { :controller => 'admin/users', action => 'edit', id => '1' } from GET /admin/users/1;edit" do
      params_from(:get, "/admin/users/1/edit").should == {:controller => "admin/users", :action => "edit", :id => "1"}
    end

    it "should generate params { :controller => 'admin/users', action => 'update', id => '1' } from PUT /admin/users/1" do
      params_from(:put, "/admin/users/1").should == {:controller => "admin/users", :action => "update", :id => "1"}
    end

    it "should generate params { :controller => 'admin/users', action => 'destroy', id => '1' } from DELETE /admin/users/1" do
      params_from(:delete, "/admin/users/1").should == {:controller => "admin/users", :action => "destroy", :id => "1"}
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

