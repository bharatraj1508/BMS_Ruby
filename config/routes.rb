Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users,
    path_names: {
      sign_in: "login",
      sign_out: "logout",
    },
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
      # invitations: "users/invitations",
      passwords: "users/passwords",
      confirmations: "users/confirmations"
    }
  
  # authenticated :user, lambda { |u| u.super_admin? } do
  # end

  get "/home", to: "home#index"

  # Account Routes
  resources :accounts, only: [:new, :create]
  patch "/accounts/switch", to: "accounts#switch"

  #invitation routes
  get "account/invite", to: "invitations/account_invitation#new"
  post "account/invite", to: "invitations/account_invitation#create"

  get "invitations/:id/accept", to: "invitations/account_invitation#accept", as: "accept_invitation"
  get "invitations/:id/decline", to: "invitations/account_invitation#decline", as: "decline_invitation"
  get "invitations/:id/setup_profile", to: "invitations/account_invitation#setup_profile", as: "setup_profile"

  root to: 'pages#index'
end
