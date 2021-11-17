Rails.application.routes.draw do

  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  }
  root 'posts#index'
  resources :posts
  post '/callback' => 'linebot#callback'
  post '/push' => 'linebot#push'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
