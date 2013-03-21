BookmarkSite::Application.routes.draw do

  match 'usernotfound' => 'static_pages#usernotfound', as: 'usernotfound'

  resources :sessions, :only => [:create]
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  root :to => "static_pages#welcome"

  #match '/sessions(.:format)' => 'sessions#create', :via => :post

  get "jsfiles/bookmarklet(.:format)" => "jsfiles#bookmarklet", :as => :bookmarklet
  get "jsfiles/jquery_bookmarklet.min(.:format)" => "jsfiles#jquery_bookmarklet", :as => :bookmarklet_setup
  get "jsfiles/cleanslate(.:format)" => "jsfiles#cleanslate", :as => :cleanslate
  get "jsfiles/playground(.:format)" => "jsfiles#playground", :as => :playground
  #get "jsfiles/embed(.:format)" => "jsfiles#embed", :as => :embed
  match 'jsfiles/process_bookmarklet(.:format)' => 'jsfiles#process_bookmarklet', :via => :post
  match 'jsfiles/process_bookmarklet(.:format)' => 'jsfiles#preflight', :via => :options

  # match 'sessions' => 'sessions#preflight', :via => :options

  match 'playlists/:playlist_id/user_bookmarks/:id/move(.:format)' => 'user_bookmarks#move', :via => :post
  # get 'playlists/:id/destroy_bookmark/:bookmark_id' => 'playlists#destroy_bookmark'
  # get 'playlists/:id/new_bookmark' => 'playlists#new_bookmark'

  get 'welcome', to: 'static_pages#welcome', as: 'welcome'
  get 'about', to: 'static_pages#about', as: 'about'
  get 'info', to: 'static_pages#info', as: 'info'
  get 'privacy', to: 'static_pages#privacy', as: 'privacy'
  get 'contact', to: 'static_pages#contact', as: 'contact'

  resources :playlists do
    resources :user_bookmarks
  end

  resources :bookmark_urls, :only => [:create]

  match 'users/temp(.:format)' => 'users#temp', :as => :temp_users, :via => :get
  match 'users/create_temp(.:format)' => 'users#create_temp', :as => :create_temp_users, :via => :get

  resources :users do
    member do
      get 'upgrade'
      put 'process_upgrade'
    end
    # get 'upgrade'
  end


  match '/:username' => 'users#show'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
