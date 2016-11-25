Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  get 'home/api_ai'
  root "home#index"
  mount Messenger::Bot::Space => "/webhook"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
