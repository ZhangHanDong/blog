require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module UserSweeperSpecHelper

  def valid_user_attributes
    {
      :login => 'jimmy',
      :email => 'jim@bomb.com',
      :password => 'monkey',
      :password_confirmation => 'monkey'
    }
  end

end


describe UserSweeper do

  include UserSweeperSpecHelper

  before(:each) do
    @sweeper = UserSweeper.instance
  end


  describe "after create" do

    before(:each) do
      @user = User.new(valid_user_attributes)
    end

    it "should not expire" do
      @sweeper.should_not_receive(:expire_all).with(@user)
      @user.save!
    end

  end


  describe "after update" do

    before(:each) do
      @user = User.create!(valid_user_attributes)
    end

    it "should not expire when nothing changed" do
      @sweeper.should_not_receive(:expire_all).with(@user)
      @user.save!
    end

    it "should expire when name changed" do
      @sweeper.should_receive(:expire_all).with(@user)
      @user.name = "new name"
      @user.save!
    end

    it "should expire when email changed" do
      @sweeper.should_receive(:expire_all).with(@user)
      @user.email = "new@email.com"
      @user.save!
    end

  end


  describe "after destroy" do

    before(:each) do
      @user = User.create!(valid_user_attributes)
    end

    it "should always expire" do
      @sweeper.should_receive(:expire_all).with(@user)
      @user.destroy
    end

  end

end