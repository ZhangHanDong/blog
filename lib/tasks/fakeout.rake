# generates some random fake data for the app (using faker)
require 'faker'

namespace :fake do

  desc "clean away all data"
  task :clean => :environment do
    User.delete_all
    Blog.delete_all
    Post.delete_all
    Tag.delete_all
    Tagging.delete_all
    Comment.delete_all
    Upload.delete_all
  end
  
  desc "fake out data in application (small dataset)"
  task :small => :clean do
    fakeout({:users    => 1+rand(2),
             :blogs    => 2+rand(1),
             :posts    => 5+rand(5),
             :comments => 6+rand(4)})
  end
  
  desc "fake out data in application (medium dataset)"
  task :medium => :clean do
    fakeout({:users    => 4+rand(6),
             :blogs    => 5+rand(5),
             :posts    => 20+rand(20),
             :comments => 25+rand(20)})
  end
  
  desc "fake out data in application (large dataset)"
  task :large => :clean do
    fakeout({:users    => 20+rand(50),
             :blogs    => 20+rand(10),
             :posts    => 100+rand(1000),
             :comments => 200+rand(1000)})
  end
  
  def fakeout(number_of)
    1.upto(number_of[:users]) do
      User.create!(:login    => Faker::Internet.user_name,
                   :name     => Faker::Name.name,
                   :email    => Faker::Internet.email,
                   :password => 'testpass',
                   :password_confirmation => 'testpass')
    end

    1.upto(number_of[:blogs]) do
      Blog.create!(:title         => Faker::Lorem.sentence(1+rand(2)).chop,
                   :short_name    => Faker::Internet.domain_word,
                   :created_by_id => pick_random(User).id)
    end

    1.upto(number_of[:posts]) do
      Post.create!(:title        => Faker::Lorem.sentence(2+rand(6)).chop,
                   :publish_date => Date.today-(1+rand(365)).days,
                   :summary      => Faker::Lorem.paragraph(rand(3)),
                   :body         => Faker::Lorem.paragraph(1+rand(5)),
                   :tag_list     => Faker::Lorem.words(rand(3)).join(' '),
                   :in_draft     => false,
                   :user         => pick_random(User),
                   :blog         => pick_random(Blog))
    end

    1.upto(number_of[:comments]) do
      Comment.create!(:name             => Faker::Name.name,
                      :email            => Faker::Internet.email,
                      :website          => "www.#{Faker::Internet.domain_name}",
                      :body             => Faker::Lorem.paragraph(1+rand(3)),
                      :post             => pick_random(Post),
                      :user             => pick_random(User, true),
                      :spam_question_id => 1,
                      :spam_answer      => 'cold')
    end

    puts "Faked:"
    puts "Users: #{number_of[:users]}"
    puts "Blogs: #{number_of[:blogs]}"
    puts "Posts: #{number_of[:posts]}"
    puts "Comments: #{number_of[:comments]}"
    puts "Tags: #{Tag.count(:all)}"
    puts "OK, try login with #{User.find(:first).login}:testpass"
  end

  def pick_random(model_name, optional = false)
    model = model_name.find(:first, :order => 'RAND()')
    return nil if optional && (rand(2) > 0)
    model
  end

end