Tasking::Application.routes.draw do
  get "sign_up"  => "accounts#new", as: :sign_up
  get "sign_in"  => "sessions#new", as: :sign_in
  get "sign_out" => "sessions#destroy", as: :sign_out

  get "edit_stuff" => "home#edit", as: :edit_stuff

  # authentication
  resources :accounts, only: [:new, :create] do
    get "activate/:token", as: :activate, on: :collection, action: :activate
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :create, :edit, :update]

  # backlog
  resources :stories do
    collection do
      match "update_velocity", via: [:get, :post]
    end
    member do
      match "update_position", via: [:get, :post]
    end
  end

  # config
  resources :teammates

  root "home#index"

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

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
