# Be sure to restart your server when you modify this file.

# ApplicationController.renderer.defaults.merge!(
#   http_host: 'example.org',
#   https: false
# )

# YOUR_APP/config/initializers/messenger.rb
Messenger.configure do |config|
  config.verify_token      = 'computer-extras-express' #will be used in webhook verifiction
  config.page_access_token = 'EAAbZA5E3Ec5MBAO5O3WFp8xXDipgC4ebjmsdZA8QmGsHxPm2qwvAZBg3ZABTqra4uJiYPf3iGnXU0v2ch24VQJVbmpSD6tqZAsfm9wTDsSPZANkiYfPjeakaULZBZBTlWkVGS6ixUDFVVooS8Gbu0znTZAEMmXZAQhgCRLwkpLtgWhtdjBvMVv82lS'
end