Rails.application.routes.draw do
  resources :messages
  resources :clients
  devise_for :users
  get 'home/index'
  get 'home/api_ai'

  get 'home/bot_chats'
  get 'home/bot_assistant_chat'
  get 'home/client_chat'
  get 'home/client_chat_reply'
  post 'home/send_message'

  #root "home#index"
  get 'home/authorize'
  post 'home/before_authorize'
  get 'dashboard/index'
  get 'home/solution'


  root "dashboard#index"
  mount Messenger::Engine, at: "/messenger"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
