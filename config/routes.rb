EmergenChef::Application.routes.draw do
  require 'sidekiq/web'
=begin
  delete 'destroy_order' => 'orders#destroy', :as => :destroy_order_path
  post 'orders' => 'orders#create'
  update method
=end

  get "about/adam" => "statics#adam", :as => :adam
  get "orders/new" => 'orders#new', :as => :new_order
  resources :orders, only:[:create, :destroy, :edit, :update]
  get 'orders/:id' => 'orders#show', :as => :show_order
  post 'orders/:id' => 'orders#alert', :as => :send_order_email
  root 'users#welcome'
  get 'usres' => 'users#index', :as => :users
  get 'users/:id' => 'users#show', :as => :user
  patch 'users/:id' => 'users#update'
  get 'users/:id/verify/:verification_token' => 'users#verify', :as => :verify_user
  post 'users' => 'users#create'
  get 'sign_up' => 'users#new', :as => :new_user
  delete 'sign_out' => 'auths#destroy', :as => :auths
  get 'sign_in' => 'auths#new', :as => :new_auth
  resources :auths, only:[ :create]
  
  mount Sidekiq::Web => '/sidekiq'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
