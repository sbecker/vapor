ActionController::Routing::Routes.draw do |map|
  # Restful Authentication Named Routes
  map.logout   '/logout',                    :controller => 'sessions', :action => 'destroy'
  map.login    '/login',                     :controller => 'sessions', :action => 'new'
  map.register '/register',                  :controller => 'users',    :action => 'create'
  map.signup   '/signup',                    :controller => 'users',    :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users',    :action => 'activate', :activation_code => nil

  map.dashboard '/dashboard',                :controller => 'dashboard', :action => 'index'
  
  # Restful Authentication Resource Routes
  map.resources :users, :member => { :suspend   => :put,
                                     :unsuspend => :put,
                                     :purge     => :delete }
  map.resource :session

  # Vapor Resource Routes
  map.resources :accounts

  map.root :controller => 'dashboard'

  # # Install the default routes as the lowest priority.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
