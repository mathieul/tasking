Tasking::Application.routes.draw do
  # authentication
  resources :accounts, only: [:new, :create, :edit, :update] do
    get "activate/:token", as: :activate, on: :collection, action: :activate
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :create, :edit, :update]

  # friendly authentication links
  get "sign_up"  => "accounts#new", as: :sign_up
  get "sign_in"  => "sessions#new", as: :sign_in
  get "sign_out" => "sessions#destroy", as: :sign_out

  # backlog
  resources :stories do
    collection do
      get  :refresh
      post :update_velocity
    end
    member do
      post :update_position
    end
  end

  # sprints
  resources :sprints, only: [:index, :new, :create, :edit, :update] do
    collection do
      get :refresh
    end
  end
  resources :taskable_stories, only: [:update] do
    resources :tasks, only: [:create, :update, :destroy] do
      member do
        post :progress
        post :complete
      end
    end
  end

  # config
  resources :teammates do
    collection do
      get :export
      get :import_form
      get  :refresh
      post :import
    end
  end

  root to: "home#redirect"
end
