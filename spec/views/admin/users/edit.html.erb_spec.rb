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
    
    response.should have_tag("form[action=#{admin_user_path(@user)}][method=post]") do
      with_tag('input#user_login[name=?]', "user[login]")
      with_tag('input#user_name[name=?]', "user[name]")
      with_tag('input#user_email[name=?]', "user[email]")
      with_tag('input#user_password[name=?]', "user[password]")
      with_tag('input#user_password_confirmation[name=?]', "user[password_confirmation]")
    end
  end
end


