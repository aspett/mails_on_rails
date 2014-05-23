Mails::Application.routes.draw do
  get "business_management/index"
  get "business_management/figures", as: "business_figures"
  get "business_management/logs", as: "business_logs"
  root 'home#index'
  resources :mails
  resources :mail_routes, except: :destroy
  put "/mail_routes/discontinue/:id" => 'mail_routes#discontinue', as: "discontinue_route"
  put "/mail_routes/recontinue/:id" => 'mail_routes#recontinue', as: "recontinue_route"
    #index, show, new, create, edit, delete

  resources :users 
  put "/users/:id/promote" => "users#promote", as: "promote_user"
  put "/users/:id/demote" => "users#demote", as: "demote_user"
  # Sets up create/delete route for session controller
  resources :sessions, only: [:create, :delete]
  get "/login" => "sessions#new", as: "login"
  get "/logout" => "sessions#delete", as: "logout"
  get "/business_management" => "business_management#index", as: "business_management"
  get "/gen_lat_lon" => "home#generate"
end
