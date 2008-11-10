require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/posts/edit.html.erb" do
  include Admin::PostsHelper
  
  before do
    @user = mock_model(User)
    @user.stub!(:login).and_return("MyString")
    @user.stub!(:name).and_return("MyString") 
    @user.stub!(:email).and_return("MyString")
    @user.stub!(:password).and_return("MyString")
    @user.stub!(:password_confirmation).and_return("MyString") 
    assigns[:user] = @user
  end

  it "should render edit user form" do
    render "/admin/users/edit.html.erb"
    
    response.should have_tag("form[action=#{admin_user_path(@user)}][method=post]")
    response.should have_tag('input#user_login[name=?]', "user[login]")
    response.should have_tag('input#user_name[name=?]', "user[name]")
    response.should have_tag('input#user_email[name=?]', "user[email]")
    response.should have_tag('input#user_password[name=?]', "user[password]")
    response.should have_tag('input#user_password_confirmation[name=?]', "user[password_confirmation]")
  end
end


