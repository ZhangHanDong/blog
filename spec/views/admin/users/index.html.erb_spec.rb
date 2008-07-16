require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/users/index.html.erb" do
  include Admin::UsersHelper
  
  before(:each) do
    user_98 = mock_model(User)
    user_98.stub!(:login).and_return("MyString")
    user_98.stub!(:name).and_return("MyString") 
    user_98.stub!(:email).and_return("MyString")   
    user_98.stub!(:photo).and_return(nil)   
    user_99 = mock_model(User)
    user_99.stub!(:login).and_return("MyString")
    user_99.stub!(:name).and_return("MyString") 
    user_99.stub!(:email).and_return("MyString")   
    user_99.stub!(:photo).and_return(nil) 
    assigns[:users] = [user_98, user_99]  
    assigns[:users].stub!(:total_pages).and_return(0)  
  end

  it "should render list of users" do
    render "/admin/users/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
  end
end

