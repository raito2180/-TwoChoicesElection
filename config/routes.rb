Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'tops#index'

  resources :users, only: [:destroy]

  resources :videos do
    collection do
      get 'search'
    end
  end

  resources :profiles, only: [:show, :edit, :update]

  resources :responses

  resources :posts do
    resources :groups do
      resources :memberships, only: [:create, :update] do
        resource :chatroom, only: [:show]
      end
    end
  end

  get '/400', to: 'errors#bad_request', as: :bad_request
  get '/401', to: 'errors#unauthorized', as: :unauthorized
  get '/403', to: 'errors#forbidden', as: :forbidden
  get '/404', to: 'errors#not_found', as: :not_found
  get '/500', to: 'errors#internal_server_error', as: :internal_server_error
  get '/502', to: 'errors#bad_gateway', as: :bad_gateway
  get '/503', to: 'errors#service_unavailable', as: :service_unavailable
  get '/504', to: 'errors#gateway_timeout', as: :gateway_timeout

  resources :contacts, only: [:new, :create]
  get 'done', to: 'contacts#done', as: 'done'

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
