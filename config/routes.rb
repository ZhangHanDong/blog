ActionController::Routing::Routes.draw do |map|

  # mapped routes
  map.admin  '/admin',  :controller => 'admin/blogs'
  map.logout '/logout', :controller => 'sessions',   :action => 'destroy'
  map.login  '/login',  :controller => 'sessions',   :action => 'new'
  map.signup '/signup', :controller => 'admin/users', :action => 'signup'


  # public resources
  map.resource  :session
  map.resources :blogs, :collection => { :on => :get } do |blog|

    map.connect 'blogs/:blog_id/on/:year/:month/:day',
                        :controller => 'posts',
                        :action     => 'on',
                        :month => nil, :day => nil,
                        :requirements => { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ }

    blog.resources :posts, :has_many => :comments
    blog.resources :comments
    blog.resources :tags, :has_many => :posts
    blog.resources :users, :has_many => [:posts, :comments, :tags]
  end


  # admin resources
  map.namespace :admin do |admin|

    admin.resources :blogs do |blog|
      blog.resources :posts, :has_many => :comments
      blog.resources :comments
      blog.resources :tags, :has_many => :posts
      blog.resources :users, :has_many => [:posts, :comments, :tags]
    end

    admin.resources :users, :has_many => [:blogs, :posts, :comments]
  end


  # defaults
  map.root   :blogs
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
