Rails.application.routes.draw do
  root 'posts#index'
  devise_for :users
  resources :posts do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end

  namespace :api do
    namespace :v1 do
      # devise_for :users, controllers: {
      #   registrations: 'api/v1/registrations',
      #   sessions: 'api/v1/sessions'
      # }
         # Add signup and signin routes directly
      devise_scope :user do
        post 'signup', to: 'registrations#create'
        post 'signin', to: 'sessions#create'
      end
      
      resources :users, only: [:show]
      resources :posts do
        resources :comments, only: [:index, :create]
      end
    end
  end

end
