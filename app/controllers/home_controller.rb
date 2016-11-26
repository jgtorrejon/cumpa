class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:index,:bot_chats,:bot_assistant_chat,:client_chat,:client_chat_reply]
  before_action :set_client, only: [:client_chat]

  def index

  end

  def bot_chats
    @clients = Client.where(:bot_service => true)
  end

  def bot_assistant_chat
    @clients = Client.where(:bot_service => false)
  end

  def client_chat
  end

  def client_chat_reply
    @client = Client.find(params[:client_id])
  end

  def send_message
    message = params[:message]
    respond_to do |format|
        format.html { redirect_to home_client_chat_reply_path(client_id: params[:client_id]), notice: 'Client was successfully updated.' }
    end
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
