require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/users/show.html.erb" do
  include Admin::UsersHelper
  
  before(:each) do
    @user = mock_model(User)
    @user.stub!(:login).and_return("MyString1")
    @user.stub!(:name).and_return("MyString2")
    @user.stub!(:email).and_return("MyString3")    
    @user.should_receive(:photo)     
    @user.should_receive(:created_blogs).twice.and_return([]) 
    @user.should_receive(:posts).twice.and_return([])
    @user.should_receive(:comments).twice.and_return([]) 
    @user.should_receive(:blogs).twice.and_return([]) 
    assigns[:user] = @user
  end

  it "should render an individual user" do
    render "/admin/users/show.html.erb"
    response.should have_text(/MyString1/)
    response.should have_text(/MyString2/)
    response.should have_text(/MyString3/)
  end
end

