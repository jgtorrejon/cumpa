class MessengerController < Messenger::MessengerController
  def webhook
    # text=params[:entry].first["messaging"].first["message"][:text]
    fb_params.entries.each do |entry|
      process_response(entry)
    end
    render nothing: true, status: 200

  end

  def process_response(entry)
    entry.messagings.each do |messaging|
      @user_id=messaging.sender_id
      if messaging.callback.message?
        receive_message(messaging.callback)
      elsif messaging.callback.delivery?
        puts messaging.callback
      elsif messaging.callback.postback?
        receive_postback(messaging.callback)
      elsif messaging.callback.optin?
        puts messaging.callback
      elsif messaging.callback.account_linking?
        puts messaging.callback
      end
      puts Messenger::Client.get_user_profile(messaging.sender_id)


      # Messenger::Client.send(
      #     Messenger::Request.new(
      #         Messenger::Elements::Text.new(text: "Echo: #{messaging.callback.text}"),
      #         messaging.sender_id
      #     )
      # )

    end
  end

  def receive_message(message)
    unless message.text.nil?
      model_response=send_to_api_ai(message.text)
      # get user from Facebook
      facebook_user = Messenger::Client.get_user_profile(@user_id)
      #create client of find client by sender_id
      client = Client.where(sender_id: @user_id).first || Client.create(name: facebook_user["first_name"], last_name: facebook_user["last_name"], picture: facebook_user["profile_pic"], sender_id: @user_id)
      # save message text => from client to bot
      Message.create(message: message.text, fb_message_id: message.mid, client_id: client.id, bot:false)
      command_response= model_response[:result][:action] # accion
      message_response= model_response[:result][:fulfillment][:speech] #respuesta
      puts message_response
      clasify_messagin(command_response, message_response)
    end

    unless message.attachments.nil?
      puts message.attachments
    end
  end

  def receive_postback(command)
    # save postback from client to bot
    facebook_user = Messenger::Client.get_user_profile(@user_id)
    #create client of find client by sender_id
    client = Client.where(sender_id: @user_id).first || Client.create(name: facebook_user["first_name"], last_name: facebook_user["last_name"], picture: facebook_user["profile_pic"], sender_id: @user_id)
    # save message text => from client to bot
    Message.create(message: command.payload, client_id: client.id, bot:false)
    clasify_postback(command.payload)
  end

  def api_ai_model(hash_response)
    model_api_ai= Struct.new(hash_response)
  end

  def send_to_api_ai(text)
    client = ApiAiRuby::Client.new(:client_access_token => self.ACCESS_TOKEN)
    response = client.text_request text
  end

  def ACCESS_TOKEN
    '5d8413c5badb49b4969a6e70a9d65edb' #todo new struct by joel
  end

  def clasify_messagin(command, response_text)
    puts [command,response_text]
    case command
      when "UNKNOWN"
        #
        response = "No te entiendo, te paso a mi supervisor, espera un momento"
        #save boot message
        client = Client.where(sender_id: @user_id).first
        Message.create(message: response, client_id: client.id, bot:true,user_id: 1)
        # trigger => NOTICE TO USER TO CHECK MESSAGE
        request_base(Messenger::Elements::Text.new(text: response))
      when "FAQS_GET_CARD"
        # save response text => from bot to client
        client = Client.where(sender_id: @user_id).first
        Message.create(message: response_text, client_id: client.id, bot:true)
        # send message
        request_base(Messenger::Elements::Text.new(text: response_text))

      when "FAQS_OPEN_ACCOUNT"
        response = "¿Juridico ó Natural?"
        client = Client.where(sender_id: @user_id).first
        Message.create(message: response, client_id: client.id, bot:true)
        request_base(Messenger::Templates::Buttons.new(
            text: response_text,
            buttons: [
                Messenger::Elements::Button.new(type: 'postback', title: 'Juridico', value: 'FAQS_OPEN_ACCOUNT_JURIDICO'),
                Messenger::Elements::Button.new(type: 'postback', title: 'Natural', value: 'FAQS_OPEN_ACCOUNT_NATURAL')
            ]
        ))
      when "SMALLER_QUEUE"
        offices = Office.limit(3).order('quantity_of_people ASC')
        response = ""
        offices.each do |office|
          response += office.name + " : " + office.localization + " : " + office.quantity_of_people.to_s + " personas.\u000A"
        end
        client = Client.where(sender_id: @user_id).first
        Message.create(message: response, client_id: client.id, bot:true)
        request_base(Messenger::Elements::Text.new(text: response.encode('utf-8')))

    end
  end
  def clasify_postback(command)
    case command
      when "FAQS_OPEN_ACCOUNT_NATURAL"
        response_text = "Solo Necesitas llevar tu carnet de identidad."
        client = Client.where(sender_id: @user_id).first
        Message.create(message: response_text, client_id: client.id, bot:true)
        request_base(Messenger::Elements::Text.new(text: response_text))
      when "FAQS_OPEN_ACCOUNT_JURIDICO"
        response_text = "Necesitas Documento legal de la empresa y representantes."
        client = Client.where(sender_id: @user_id).first
        Message.create(message: response_text, client_id: client.id, bot:true)
        request_base(Messenger::Elements::Text.new(text: "Necesitas Documento legal de la empresa y representantes."))
    end
  end

  def request_base(data)
    Messenger::Client.send(
        Messenger::Request.new(
            data,
            @user_id
        )
    )
  end
end
