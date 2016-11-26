Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  get 'home/api_ai'

  get 'home/bot_chats'
  get 'home/bot_assistant_chat'

  root "home#index"
  mount Messenger::Engine, at: "/messenger"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
