Tasking::Application.routes.draw do
  # allow get for use with wiselinks
  concern :wiselinkable do
    collection do
      get "create", as: "create"
    end
    member do
      get "update", as: "update"
    end
  end
  concern :wiselinkable_destroy do
    member do
      get "destroy", as: "destroy"
    end
  end

  # authentication
  resources :accounts, only: [:new, :create] do
    get "activate/:token", as: :activate, on: :collection, action: :activate
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :create, :edit, :update]

  # friendly authentication links
  get "sign_up"  => "accounts#new", as: :sign_up
  get "sign_in"  => "sessions#new", as: :sign_in
  get "sign_out" => "sessions#destroy", as: :sign_out

  # backlog
  resources :stories, concerns: [:wiselinkable, :wiselinkable_destroy] do
    collection do
      match "update_velocity", via: [:get, :post]
    end
    member do
      match "update_position", via: [:get, :post]
    end
  end

  # sprints
  resources :sprints, only: [:index, :new, :create, :edit, :update] do
    concerns :wiselinkable
    resources :tasks, only: [:create, :update, :destroy],
                      concerns: [:wiselinkable, :wiselinkable_destroy]
  end

  # config
  resources :teammates, concerns: [:wiselinkable, :wiselinkable_destroy]

  root to: "home#redirect"
end
