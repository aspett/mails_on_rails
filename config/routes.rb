Mails::Application.routes.draw do
<<<<<<< HEAD
  get "business_management/index"
  get "business_management/figures"
  get "business_management/logs"
  get "mail_routes/index"
  get "mail_routes/show"
  get "mail_routes/edit"
  get "mail_routes/new"
  get "mail_routes/delete"
  get "home/index"
=======
>>>>>>> f2b3ae4e1c98169c7d8e488abaa5d8df4f9a2a91
  root 'home#index'
  resources :mails
  resources :mail_routes #index, show, new, create, edit, delete
  # Sets up create/delete route for session controller
  resources :sessions, only: [:create, :delete]
  get "/login" => "sessions#new", as: "login"
end
