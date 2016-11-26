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

  def authorize
  @uri=params[:redirect_uri]
  end

  def before_authorize
   email= params[:email]
   password=params[:password]
   uri_redirect=params[:redirect_uri]
   authorization_code="12345678"
   uri_redirect+="?authorization_code="+authorization_code
   redirect_to uri_redirect
  end


  private
  def set_client
    @client = Client.find(params[:client_id])
  end

end
