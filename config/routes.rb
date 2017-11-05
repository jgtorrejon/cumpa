Rails.application.routes.draw do
  # Root
  root "dashboard#index"

  # Resources
  resources :messages
  resources :clients
  devise_for :users  

  # Routes
  get 'home/index'
  get 'home/api_ai'
  get 'home/bot_chats'
  get 'home/bot_assistant_chat'
  get 'home/client_chat'
  get 'home/client_chat_reply'
  get 'home/authorize'
  get 'home/solution'
  get 'dashboard/index'
  post 'home/send_message'
  post 'home/before_authorize'

  # Mounts
  mount Messenger::Engine, at: "/messenger"  
end
