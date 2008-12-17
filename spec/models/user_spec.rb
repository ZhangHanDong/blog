# -*- coding: mule-utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe User do

  fixtures :users, :blogs, :posts, :taggings, :tags, :comments

  describe 'being created' do
    before do
      @user = nil
      @creating_user = lambda do
        @user = create_user
        violated "#{@user.errors.full_messages.to_sentence}" if @user.new_record?
      end
    end

    it 'increments User#count' do
      @creating_user.should change(User, :count).by(1)
    end
  end


  describe 'named scopes' do

    it "should have a recent scope that returns up to 20 users ordered by created_at DESC" do
      User.should have_named_scope(:recent, {:limit=>20, :order=>"users.created_at DESC"})
    end

  end


  describe 'being associated with' do

    it "should have created blogs" do
      users(:quentin).created_blogs.should eql([blogs(:one)])
    end

    it "should have blogs (through posts)" do
      users(:quentin).blogs.should eql([blogs(:one)])
    end

    it "should have posts" do
      users(:quentin).posts.should eql([posts(:normal_post)])
    end

    it "should have comments" do
      users(:quentin).comments.should eql([comments(:normal_comment)])
    end

    it "should have taggings" do
      users(:quentin).taggings.should eql([taggings(:normal_tagging)])
      users(:aaron).taggings.should be_empty
    end

    it "should have tags through taggings" do
      users(:quentin).tags.should eql([tags(:normal_tag)])
      users(:aaron).tags.should be_empty
    end
  end


  describe 'having an optional photo' do

    it "should have a photo" do
      user = create_user({:photo => fixture_file_upload('files/50x50.png', 'image/png')})
      user.photo.should_not be_nil
    end

    it "should be a valid image type" do
      user = create_user({:photo => fixture_file_upload('files/50x50.png', 'image/x-png')})
      user.should have(1).error_on(:photo)
    end

  end


  #
  # Validations
  #
  describe 'being validated' do

    it 'requires login' do
      lambda do
        u = create_user(:login => nil)
        u.errors.on(:login).should_not be_nil
      end.should_not change(User, :count)
    end

    describe 'allows legitimate logins:' do
      ['123', '1234567890_234567890_234567890_234567890',
       'hello.-_therefunnychar.com'].each do |login_str|
        it "'#{login_str}'" do
          lambda do
            u = create_user(:login => login_str)
            u.errors.on(:login).should     be_nil
          end.should change(User, :count).by(1)
        end
      end
    end
    describe 'disallows illegitimate logins:' do
      ['12', '1234567890_234567890_234567890_234567890_', "tab\t", "newline\n",
       "Iñtërnâtiônàlizætiøn hasn't happened to ruby 1.8 yet",
       'semicolon;', 'quote"', 'tick\'', 'backtick`', 'percent%', 'plus+', 'space '].each do |login_str|
        it "'#{login_str}'" do
          lambda do
            u = create_user(:login => login_str)
            u.errors.on(:login).should_not be_nil
          end.should_not change(User, :count)
        end
      end
    end

    it 'requires password' do
      lambda do
        u = create_user(:password => nil)
        u.errors.on(:password).should_not be_nil
      end.should_not change(User, :count)
    end

    it 'requires password confirmation' do
      lambda do
        u = create_user(:password_confirmation => nil)
        u.errors.on(:password_confirmation).should_not be_nil
      end.should_not change(User, :count)
    end

    it 'requires email' do
      lambda do
        u = create_user(:email => nil)
        u.errors.on(:email).should_not be_nil
      end.should_not change(User, :count)
    end

    describe 'allows legitimate emails:' do
      ['foo@bar.com', 'foo@newskool-tld.museum', 'foo@twoletter-tld.de', 'foo@nonexistant-tld.qq',
       'r@a.wk', '1234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890@gmail.com',
       'hello.-_there@funnychar.com', 'uucp%addr@gmail.com', 'hello+routing-str@gmail.com',
       'domain@can.haz.many.sub.doma.in',
      ].each do |email_str|
        it "'#{email_str}'" do
          lambda do
            u = create_user(:email => email_str)
            u.errors.on(:email).should     be_nil
          end.should change(User, :count).by(1)
        end
      end
    end
    describe 'disallows illegitimate emails' do
      ['!!@nobadchars.com', 'foo@no-rep-dots..com', 'foo@badtld.xxx', 'foo@toolongtld.abcdefg',
       'Iñtërnâtiônàlizætiøn@hasnt.happened.to.email', 'need.domain.and.tld@de', "tab\t", "newline\n",
       'r@.wk', '1234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890@gmail2.com',
       # these are technically allowed but not seen in practice:
       'uucp!addr@gmail.com', 'semicolon;@gmail.com', 'quote"@gmail.com', 'tick\'@gmail.com', 'backtick`@gmail.com', 'space @gmail.com', 'bracket<@gmail.com', 'bracket>@gmail.com'
      ].each do |email_str|
        it "'#{email_str}'" do
          lambda do
            u = create_user(:email => email_str)
            u.errors.on(:email).should_not be_nil
          end.should_not change(User, :count)
        end
      end
    end

    describe 'allows legitimate names:' do
      ['Andre The Giant (7\'4", 520 lb.) -- has a posse',
       '', '1234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890',
      ].each do |name_str|
        it "'#{name_str}'" do
          lambda do
            u = create_user(:name => name_str)
            u.errors.on(:name).should     be_nil
          end.should change(User, :count).by(1)
        end
      end
    end
    describe "disallows illegitimate names" do
      ["tab\t", "newline\n",
       '1234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_',
       ].each do |name_str|
        it "'#{name_str}'" do
          lambda do
            u = create_user(:name => name_str)
            u.errors.on(:name).should_not be_nil
          end.should_not change(User, :count)
        end
      end
    end

    it 'resets password' do
      users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
      User.authenticate('quentin', 'new password').should == users(:quentin)
    end

    it 'does not rehash password' do
      users(:quentin).update_attributes(:login => 'quentin2')
      users(:quentin).update_attributes(:password => 'monkey', :password_confirmation => 'monkey')
      User.authenticate('quentin2', 'monkey').should == users(:quentin)
    end

  end

  #
  # Authentication
  #

  it 'authenticates user' do
    users(:quentin).update_attributes(:login => 'quentin')
    users(:quentin).update_attributes(:password => 'monkey', :password_confirmation => 'monkey')
    User.authenticate('quentin', 'monkey').should == users(:quentin)
  end

  it 'authenticates user with email address' do
    users(:quentin).update_attributes(:email => 'quentin@hotdog.com')
    users(:quentin).update_attributes(:password => 'monkey', :password_confirmation => 'monkey')
    User.authenticate('quentin@hotdog.com', 'monkey').should == users(:quentin)
  end

  it "doesn't authenticates user with bad password" do
    User.authenticate('quentin', 'monkey2').should be_nil
  end

 if REST_AUTH_SITE_KEY.blank?
   # old-school passwords
   it "authenticates a user against a hard-coded old-style password" do
     User.authenticate('old_password_holder', 'test').should == users(:old_password_holder)
   end
 else
   it "doesn't authenticate a user against a hard-coded old-style password" do
     User.authenticate('old_password_holder', 'test').should be_nil
   end

   # New installs should bump this up and set REST_AUTH_DIGEST_STRETCHES to give a 10ms encrypt time or so
   desired_encryption_expensiveness_ms = 0.1
   it "takes longer than #{desired_encryption_expensiveness_ms}ms to encrypt a password" do
     test_reps = 100
     start_time = Time.now; test_reps.times{ User.authenticate('quentin', 'monkey'+rand.to_s) }; end_time   = Time.now
     auth_time_ms = 1000 * (end_time - start_time)/test_reps
     auth_time_ms.should > desired_encryption_expensiveness_ms
   end
 end

  #
  # Authentication
  #
  describe "being authenticated" do

    it 'sets remember token' do
      users(:quentin).remember_me
      users(:quentin).remember_token.should_not be_nil
      users(:quentin).remember_token_expires_at.should_not be_nil
    end

    it 'unsets remember token' do
      users(:quentin).remember_me
      users(:quentin).remember_token.should_not be_nil
      users(:quentin).forget_me
      users(:quentin).remember_token.should be_nil
    end

    it 'remembers me for one week' do
      before = 1.week.from_now.utc
      users(:quentin).remember_me_for 1.week
      after = 1.week.from_now.utc
      users(:quentin).remember_token.should_not be_nil
      users(:quentin).remember_token_expires_at.should_not be_nil
      users(:quentin).remember_token_expires_at.between?(before, after).should be_true
    end

    it 'remembers me until one week' do
      time = 1.week.from_now.utc
      users(:quentin).remember_me_until time
      users(:quentin).remember_token.should_not be_nil
      users(:quentin).remember_token_expires_at.should_not be_nil
      users(:quentin).remember_token_expires_at.should == time
    end

    it 'remembers me default two weeks' do
      before = 2.weeks.from_now.utc
      users(:quentin).remember_me
      after = 2.weeks.from_now.utc
      users(:quentin).remember_token.should_not be_nil
      users(:quentin).remember_token_expires_at.should_not be_nil
      users(:quentin).remember_token_expires_at.between?(before, after).should be_true
    end

  end

protected
  def create_user(options = {})
    record = User.new({ :login => 'quire',
                        :email => 'quire@example.com',
                        :password => 'quire69',
                        :password_confirmation => 'quire69' }.merge(options))
    record.save
    record
  end
end
