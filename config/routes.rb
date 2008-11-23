ActionController::Routing::Routes.draw do |map|
  
  # mapped routes
  map.admin  '/admin',  :controller => 'admin/blogs'
  map.logout '/logout', :controller => 'sessions',   :action => 'destroy'
  map.login  '/login',  :controller => 'sessions',   :action => 'new'
  map.signup '/signup', :controller => 'admin/users', :action => 'signup'


  
  # public resources
  map.resource  :session
  map.resources :blogs, :collection => { :on => :get } do |blog|
   
    # paginated listings
    map.connect 'blogs/page/:page', :controller => 'blogs', :action => 'index', :requirements => { :page => /\d+/}
    map.connect 'blogs/:blog_id/tags/page/:page', :controller => 'tags', :action => 'index', :requirements => { :page => /\d+/}
    map.connect 'blogs/:blog_id/users/page/:page', :controller => 'users', :action => 'index', :requirements => { :page => /\d+/}
    
    # paginated post listings
    map.connect 'blogs/:blog_id/posts/page/:page', :controller => 'posts', :action => 'index', :requirements => { :page => /\d+/}
    map.connect 'blogs/:blog_id/users/:user_id/posts/page/:page', :controller => 'posts', :action => 'index', :requirements => { :page => /\d+/}
    map.connect 'blogs/:blog_id/tags/:tag_id/posts/page/:page', :controller => 'posts', :action => 'index', :requirements => { :page => /\d+/}
    map.connect 'blogs/:blog_id/:year/page/:page', :controller => 'posts', :action => 'on', :requirements => { :year => /\d{4}/, :page => /\d+/}
    map.connect 'blogs/:blog_id/:year/:month/page/:page', :controller => 'posts', :action => 'on', :requirements => { :year => /\d{4}/, :month => /\d{1,2}/, :page => /\d+/}
    map.connect 'blogs/:blog_id/:year/:month/:day/page/:page', :controller => 'posts', :action => 'on', :requirements => { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/, :page => /\d+/}                          
    map.connect 'blogs/:blog_id/:tag/posts/:page', :controller => 'posts', :action => 'tagged', :requirements => { :page => /\d+/}
    
    # paginated comment listings
    map.connect 'blogs/:blog_id/comments/page/:page', :controller => 'comments', :action => 'index', :requirements => { :page => /\d+/}
    map.connect 'blogs/:blog_id/posts/:post_id/comments/page/:page', :controller => 'comments', :action => 'index', :requirements => { :page => /\d+/}
    map.connect 'blogs/:blog_id/users/:user_id/comments/page/:page', :controller => 'comments', :action => 'index', :requirements => { :page => /\d+/}
    
    map.connect 'blogs/:blog_id/:year/:month/:day/:permalink',
                        :controller => 'posts',
                        :action     => 'permalink',
                        :requirements => { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ }
   
    map.connect 'blogs/:blog_id/:year/:month/:day',
                        :controller => 'posts',
                        :action     => 'on',
                        :month => nil, :day => nil,
                        :requirements => { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ }
    
    blog.resources :posts, :has_many => :comments
    blog.resources :comments
    blog.resources :tags, :has_many => :posts
    blog.resources :users, :has_many => [:posts, :comments, :tags]             
                                                                                                                              
    map.connect 'blogs/:blog_id/:tag',         :controller => 'posts', :action => 'tagged'
    map.connect 'blogs/:blog_id/:tag.:format', :controller => 'posts', :action => 'tagged'
    
    
  end


  # admin resources
  map.namespace :admin do |admin|

    admin.resources :blogs do |blog|
      blog.resources :posts, :has_many => :comments
      blog.resources :comments
      blog.resources :tags, :has_many => :posts
      blog.resources :users, :has_many => [:posts, :comments, :tags, :uploads]
      blog.resources :uploads
    end

    admin.resources :users, :has_many => [:blogs, :posts, :comments]
  end


  # defaults
  map.root   :blogs
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
