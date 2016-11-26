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

  private
  def set_client
    @client = Client.find(params[:client_id])
  end

end
