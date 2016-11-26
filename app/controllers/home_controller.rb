class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:index,:bot_chats,:bot_assistant_chat]
  before_action :set_client, only: [:client_chat]

  def index

  end

  def bot_chats
    @clients = Client.all
  end

  def bot_assistant_chat
    
  end

  def client_chat

  end

  def api_ai
    client = ApiAiRuby::Client.new(:client_access_token => '4dd0075a420a4cdab77acf19dc3ee583')
    response = client.text_request 'quiero pizza'
    puts response.to_json
  end

  private
  def set_client
    @client = Client.find(params[:client_id])
  end

end
