Mails::Application.routes.draw do
  get "business_management/index"
  get "business_management/figures"
  get "business_management/logs"
  root 'home#index'
  resources :mails
  resources :mail_routes #index, show, new, create, edit, delete
  resources :users 
  # Sets up create/delete route for session controller
  resources :sessions, only: [:create, :delete]
  get "/login" => "sessions#new", as: "login"
  get "/business_management" => "business_management#index", as: "business_management"
end
