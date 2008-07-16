ActionController::Routing::Routes.draw do |map|

  map.admin  '/admin',  :controller => 'admin/posts'
  map.logout '/logout', :controller => 'sessions',   :action => 'destroy'
  map.login  '/login',  :controller => 'sessions',   :action => 'new'

  map.resource  :session
  map.resources :posts, :has_many => :comments

  map.namespace :admin do |admin|
    admin.resources :posts, :has_many => :comments
    admin.resources :tags
    admin.resources :users do |user|
      map.signup '/signup', :controller => 'admin/users', :action => 'signup'
    end
  end
     

  map.root :posts

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
