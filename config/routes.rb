ActionController::Routing::Routes.draw do |map|
  
  # mapped routes
  map.admin  '/admin',  :controller => 'admin/blogs', :conditions => { :method => :get }
  map.logout '/logout', :controller => 'sessions',   :action => 'destroy', :conditions => { :method => :delete }
  map.login  '/login',  :controller => 'sessions',   :action => 'new', :conditions => { :method => :get }
  map.signup '/signup', :controller => 'admin/users', :action => 'signup', :conditions => { :method => :get }
  
  
  # public resources
  map.resource  :session, :only => [:new, :create, :destroy]
  map.resources :blogs, :only => [:index, :show] do |blog|
   
    blog.resources :posts, :only => [:index], 
                           :collection => { :on => :get, :tagged => :get },
                           :member => { :permalink => :get } do |post|
      post.resources :comments, :only => [:index, :show, :create]
    end
                         
    blog.resources :users do |user|
      user.resources :posts, :comments, :tags, :only => [:index]
    end
    
    blog.resources :comments
    blog.resources :tags
                                                                                                                              
    map.connect 'blogs/:blog_id/:year/:month/:day/:permalink',
                  :controller => 'posts',
                  :action     => 'permalink',
                  :requirements => { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ },
                  :conditions => { :method => :get }
  
    map.connect 'blogs/:blog_id/:year/:month/:day',
                  :controller => 'posts',
                  :action     => 'on',
                  :month => nil, :day => nil,
                  :requirements => { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ },
                  :conditions => { :method => :get }
                  
    map.connect 'blogs/:blog_id/:tag',         :controller => 'posts', :action => 'tagged', :conditions => { :method => :get }
    map.connect 'blogs/:blog_id/:tag.:format', :controller => 'posts', :action => 'tagged', :conditions => { :method => :get }
  
    
    # paginated listings
    map.connect 'blogs/page/:page', :controller => 'blogs', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
    map.connect 'blogs/:blog_id/users/page/:page', :controller => 'users', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
                  
    # paginated post listings
    map.connect 'blogs/:blog_id/posts/page/:page', :controller => 'posts', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
    map.connect 'blogs/:blog_id/users/:user_id/posts/page/:page', :controller => 'posts', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
    map.connect 'blogs/:blog_id/tags/:tag_id/posts/page/:page', :controller => 'posts', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
    map.connect 'blogs/:blog_id/:year/page/:page', :controller => 'posts', :action => 'on', :requirements => { :year => /\d{4}/, :page => /\d+/ }, :conditions => { :method => :get }
    map.connect 'blogs/:blog_id/:year/:month/page/:page', :controller => 'posts', :action => 'on', :requirements => { :year => /\d{4}/, :month => /\d{1,2}/, :page => /\d+/}, :conditions => { :method => :get }
    map.connect 'blogs/:blog_id/:year/:month/:day/page/:page', :controller => 'posts', :action => 'on', :requirements => { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/, :page => /\d+/}, :conditions => { :method => :get }
    map.connect 'blogs/:blog_id/:tag/posts/:page', :controller => 'posts', :action => 'tagged', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
    
    # paginated comment listings
    map.connect 'blogs/:blog_id/comments/page/:page', :controller => 'comments', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
    map.connect 'blogs/:blog_id/posts/:post_id/comments/page/:page', :controller => 'comments', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
    map.connect 'blogs/:blog_id/users/:user_id/comments/page/:page', :controller => 'comments', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }          
  end


  # admin resources
  map.namespace :admin do |admin|

    admin.resources :blogs do |blog|
      blog.resources :posts, :has_many => :comments
      blog.resources :comments, :only => [:index]
      blog.resources :tags, :only => [:index, :show] do |tag|
        tag.resources :posts, :only => [:index]
      end
      blog.resources :users, :has_many => [:posts, :comments, :tags, :uploads], :only => [:index]
      blog.resources :uploads
    end

    admin.resources :users do |user|
      user.resources :blogs, :only => [:index]
      user.resources :posts, :only => [:index]
      user.resources :comments, :only => [:index]
    end

    # paginated listings
    map.connect 'admin/blogs/page/:page', :controller => 'admin/blogs', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
    map.connect 'admin/users/:user_id/blogs/page/:page', :controller => 'admin/blogs', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
    
    # paginated post listings
    map.connect 'admin/blogs/:blog_id/posts/page/:page', :controller => 'admin/posts', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
    map.connect 'admin/users/:user_id/posts/page/:page', :controller => 'admin/posts', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
    map.connect 'admin/blogs/:blog_id/users/:user_id/posts/page/:page', :controller => 'admin/posts', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
    map.connect 'admin/blogs/:blog_id/tags/:tag_id/posts/page/:page', :controller => 'admin/posts', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
    
    # paginated comment listings
    map.connect 'admin/blogs/:blog_id/comments/page/:page', :controller => 'admin/comments', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
    map.connect 'admin/blogs/:blog_id/posts/:post_id/comments/page/:page', :controller => 'admin/comments', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
    map.connect 'admin/users/:user_id/comments/page/:page', :controller => 'admin/comments', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
    map.connect 'admin/blogs/:blog_id/users/:user_id/comments/page/:page', :controller => 'admin/comments', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
    
    # paginated tag listings
    map.connect 'admin/blogs/:blog_id/tags/page/:page', :controller => 'admin/tags', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
    map.connect 'admin/blogs/:blog_id/users/:user_id/tags/page/:page', :controller => 'admin/tags', :action => 'index', :requirements => { :page => /\d+/ }, :conditions => { :method => :get }
    
  end
  
  # defaults
  map.root    :blogs
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
