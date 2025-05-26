Rails.application.routes.draw do
  # User authentication routes
  devise_for :users, path: "", path_names: {
    sign_in: "login",
    sign_out: "logout",
    registration: "signup"
  },
  controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  },
  defaults: { format: :json }

  # Post routes
  resources :posts do
    get :search, on: :collection
  end
  get "/my-posts", to: "posts#my_posts"

  # Category routes
  resources :categories, only: [ :index ]
end
