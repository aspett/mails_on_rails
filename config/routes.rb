Mails::Application.routes.draw do
  get "mail_routes/index"
  get "mail_routes/show"
  get "mail_routes/edit"
  get "mail_routes/new"
  get "mail_routes/delete"
  get "home/index"
  root 'home#index'
  # Sets up create/delete route for session controller
  resource :sessions, only: [:create, :delete]
  get "/login" => "sessions#new", as: "login"
end
