ActionController::Routing::Routes.draw do |map|
  # Restful Authentication Named Routes
  map.logout   '/logout',                    :controller => 'sessions', :action => 'destroy'
  map.login    '/login',                     :controller => 'sessions', :action => 'new'
  map.register '/register',                  :controller => 'users',    :action => 'create'
  map.signup   '/signup',                    :controller => 'users',    :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users',    :action => 'activate', :activation_code => nil

  # Vapor Named Routes
  map.dashboard '/dashboard',                :controller => 'dashboard', :action => 'index'

  # Restful Authentication Resource Routes
  map.resource  :session
  map.resources :users, :member => { :suspend   => :put,
                                     :unsuspend => :put,
                                     :purge     => :delete }

  # Vapor Resource Routes
  map.resource  :account, :member     => {:sync    => :post}
  map.resources :addresses
  map.resources :images,  :collection => {:vendors => :get, :others  => :get}
  map.resources :instances
  map.resources :key_pairs
  map.resources :security_groups

  map.root :controller => 'dashboard'

  # # Install the default routes as the lowest priority.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
