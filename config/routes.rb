Mails::Application.routes.draw do
  root 'home#index'
  resource :mails, only: [:index, :show, :new]
  get '/mail_routes' => 'mail_routes#index', as: "mail_routes_index"
  resource :mail_routes #index, show, new, create, edit, delete
  # Sets up create/delete route for session controller
  resource :sessions, only: [:create, :delete]
  get "/login" => "sessions#new", as: "login"
end
