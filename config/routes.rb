Mails::Application.routes.draw do
<<<<<<< HEAD
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
=======
  get "business_management/index"
  get "business_management/figures"
  get "business_management/logs"
>>>>>>> c84b7b3cec517531b793064713693a9c3bf02fe9
  root 'home#index'
  resources :mails
  resources :mail_routes #index, show, new, create, edit, delete
  resources :users 
  # Sets up create/delete route for session controller
  resources :sessions, only: [:create, :delete]
  get "/login" => "sessions#new", as: "login"
  get "/business_management" => "business_management#index", as: "business_management"
end
