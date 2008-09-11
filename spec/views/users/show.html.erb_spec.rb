require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/show" do           
  
  include ApplicationHelper
  include UsersHelper
  
  
  before(:each) do
    blog_1 = mock_model(Blog, :title => 'Blog Title 1')
    @user = mock_model(User)   
    @comment = mock_model(Comment)
    @post = mock_model(Post)   
    
    @user.stub!(:login).and_return("MyString1")
    @user.stub!(:name).and_return("MyString2")
    @user.stub!(:email).and_return("MyString3")    
    @user.should_receive(:photo)     
    
    assigns[:blog] = blog_1    
    assigns[:user] = @user
    assigns[:comments] = [@comment]
    assigns[:posts] = [@post]
  end
  
  it "should render list of users" do
    render "/users/show"
    response.should have_text(/MyString1/)
    response.should have_text(/MyString2/)
    response.should have_text(/MyString3/) 
  end
end
