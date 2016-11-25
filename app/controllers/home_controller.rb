class HomeController < ApplicationController
  def index

  end

  def api_ai
    client = ApiAiRuby::Client.new(:client_access_token => '4dd0075a420a4cdab77acf19dc3ee583')
    response = client.text_request 'quiero pizza'
    puts response.to_json
  end
end
