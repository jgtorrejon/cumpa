# Be sure to restart your server when you modify this file.

# ApplicationController.renderer.defaults.merge!(
#   http_host: 'example.org',
#   https: false
# )

# YOUR_APP/config/initializers/messenger.rb
Messenger.configure do |config|
  config.verify_token      = 'hackaton_bnb' #will be used in webhook verifiction
  config.page_access_token = 'EAAKXfG78pMcBAJGzoWgXNm0MfV1NncAl4DFDzF587vlVoYzkbp0kuZBJrbHpyUgLrkcQmZAxZCnWY9YwCt8d82UVoHTFoYZCK1QdAiGqRP68JIQaEqWXj1Eor3gDpireXrv7qAHnmOZBTROuiOEqXOZBcnrkDePTuqZAqTs2qzaRAZDZD'
end