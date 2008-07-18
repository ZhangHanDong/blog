ActionController::Routing::Routes.draw do |map|
  
  # mapped routes
  map.admin  '/admin',  :controller => 'admin/posts'
  map.logout '/logout', :controller => 'sessions',   :action => 'destroy'
  map.login  '/login',  :controller => 'sessions',   :action => 'new'
  map.signup '/signup', :controller => 'admin/users', :action => 'signup'
                                                                                                                          
  map.connect 'posts/:year/:month/:day',
                 :controller => 'posts',
                 :action     => 'date',
                 :month => nil, :day => nil,
                 :requirements => { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ }
                 
                 
  # mapped resources 
  map.resource  :session
  map.resources :posts, :has_many => :comments  
  map.resources :users, :has_many => :posts
  
  map.namespace :admin do |admin|                 
    admin.resources :tags    
    admin.resources :posts, :has_many => :comments
    admin.resources :users, :has_many => :posts
  end

                 
  # defaults
  map.root :posts
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
