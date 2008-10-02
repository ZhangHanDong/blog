require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/index" do      
  
  include ApplicationHelper
  include UsersHelper
  
  
  before(:each) do
    blog_1 = mock_model(Blog, :title => 'Blog Title 1')
    user_1 =  mock_model(User, :name => 'User1')
    user_2 =  mock_model(User, :name => 'User2')       
    
    assigns[:blog] = blog_1
    assigns[:users] = [user_1, user_2]
    assigns[:users].stub!(:total_pages).and_return(0)
  end
  
  it "should render list of users" do    
    render 'users/index'             
    response.should have_tag("h1",  :text => "Blog Title 1 users")    
  end
  
  describe "hCard" do
  
    it "users listing represented in hCard format" do
      render "/users/index"
      response.should have_tag('td[class=?]>a[class=?]', "vcard", "url fn")
    end
    
  end
  
end
