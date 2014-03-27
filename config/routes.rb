Mails::Application.routes.draw do
  root 'home#index'
  resources :mails
  resources :mail_routes #index, show, new, create, edit, delete
  resources :users 
  # Sets up create/delete route for session controller
  resources :sessions, only: [:create, :delete]
  get "/login" => "sessions#new", as: "login"
end
