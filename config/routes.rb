Rails.application.routes.draw do
  get 'chatroom/show'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'tops#index'

  resources :users do
    member do
      delete 'user_delete'
    end
  end

  resources :videos do
    collection do
      get 'search'
    end
  end

  resources :profiles, only: [:show, :edit ,:update]

  resources :responses

  resources :posts

  resources :groups do
    resources :memberships, only: [:create,:update] do
      resource :chatroom, only: [:show]
    end
  end

  resources :contacts, only: [:new, :create]
  get 'done', to: 'contacts#done', as: 'done'


  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
