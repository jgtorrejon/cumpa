# Be sure to restart your server when you modify this file.

# ApplicationController.renderer.defaults.merge!(
#   http_host: 'example.org',
#   https: false
# )

# YOUR_APP/config/initializers/messenger.rb
Messenger.configure do |config|
  config.verify_token      = 'cumpterextrasexpress' #will be used in webhook verifiction
  config.page_access_token = 'EAAbZA5E3Ec5MBAMPlL7vM1x0ZAt0b4bhD7FrejwtCZATzRGVksJ8yImL8o8G7PWonOAw5UMUuPYk9fHpOuiR4fry8Twz5Oi0jyUldK68PHrH71Y3ByAd0yezLI7fecCOqhQdrAaeFxwhwnWXIXX5iesCcZACyZCZCz1mex2sN3qIfEHQmEr49U'
end