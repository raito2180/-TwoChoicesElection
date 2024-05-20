Rails.application.routes.draw do

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

  resources :responses

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
