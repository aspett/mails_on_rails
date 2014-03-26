Mails::Application.routes.draw do
  root 'home#index'
  # Sets up create/delete route for session controller
  resource :sessions, only: [:create, :delete]
  get "/login" => "sessions#new", as: "login"
end
