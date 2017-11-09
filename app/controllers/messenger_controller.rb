class MessengerController < Messenger::MessengerController
  
  def webhook
    # text=params[:entry].first["messaging"].first["message"][:text]
    if params[:entry].first[:messaging].first.key?("message")
      params[:entry].first[:messaging].first[:message].delete :quick_reply
    end

    fb_params.entries.each do |entry|
      process_response(entry)
    end
    render nothing: true, status: 200
  end

  def process_response(entry)
    entry.messagings.each do |messaging|
      @user_id=messaging.sender_id
      if check_service_bot
        if messaging.callback.message?
          receive_message(messaging.callback)
        elsif messaging.callback.delivery?
          puts messaging.callback
        elsif messaging.callback.postback?
          receive_postback(messaging.callback)
        elsif messaging.callback.optin?
          puts messaging.callback
        elsif messaging.callback.account_linking?
          login_or_log_out(messaging.callback)
        end
        puts Messenger::Client.get_user_profile(messaging.sender_id)
      else
        # sent message directly
        send_directly_message_without_boot(messaging)
      end
      # Messenger::Client.send(
      #     Messenger::Request.new(
      #         Messenger::Elements::Text.new(text: "Echo: #{messaging.callback.text}"),
      #         messaging.sender_id
      #     )
      # )

    end
  end

  def check_service_bot
    facebook_user = Messenger::Client.get_user_profile(@user_id)
    #create client of find client by sender_id
    client = Client.where(sender_id: @user_id).first || Client.create(name: facebook_user["first_name"], last_name: facebook_user["last_name"], picture: facebook_user["profile_pic"], sender_id: @user_id)
    client.bot_service
  end

  def send_directly_message_without_boot(messaging)

    if messaging.callback.message?
      # Received Message
      unless messaging.callback.text.nil?
        facebook_user = Messenger::Client.get_user_profile(@user_id)
        #create client of find client by sender_id
        client = Client.where(sender_id: @user_id).first || Client.create(name: facebook_user["first_name"], last_name: facebook_user["last_name"], picture: facebook_user["profile_pic"], sender_id: @user_id)
        # save message text => from client to bot
        Message.create(message: messaging.callback.text, client_id: client.id, bot: false)
      end

    elsif messaging.callback.postback?
      #receive_postback(messaging.callback)

      facebook_user = Messenger::Client.get_user_profile(@user_id)
      #create client of find client by sender_id
      client = Client.where(sender_id: @user_id).first || Client.create(name: facebook_user["first_name"], last_name: facebook_user["last_name"], picture: facebook_user["profile_pic"], sender_id: @user_id)
      # save message text => from client to bot
      Message.create(message: essaging.callback.payload, client_id: client.id, bot: false)

    elsif messaging.callback.account_linking?
      puts messaging.callback
    end
    # puts Messenger::Client.get_user_profile(messaging.sender_id)


  end

  def receive_message(message)
    unless message.text.nil?
      model_response=send_to_api_ai(message.text)
      # get user from Facebook
      facebook_user = Messenger::Client.get_user_profile(@user_id)
      #create client of find client by sender_id
      client = Client.where(sender_id: @user_id).first || Client.create(name: facebook_user["first_name"], last_name: facebook_user["last_name"], picture: facebook_user["profile_pic"], sender_id: @user_id)
      # save message text => from client to bot
      Message.create(message: message.text, fb_message_id: message.mid, client_id: client.id, bot: false)
      command_response= model_response[:result][:action] # accion
      message_response= model_response[:result][:fulfillment][:speech] #respuesta
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
    Message.create(message: command.payload, client_id: client.id, bot: false)
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
    case command
      when "UNKNOWN"
        #
        response = "No te entiendo, te paso a mi supervisor, espera un momento"
        #save boot message
        client = Client.where(sender_id: @user_id).first
        Message.create(message: response, client_id: client.id, bot: true, user_id: 1)

        client.bot_service = false
        client.save
        request_base(Messenger::Elements::Text.new(text: response))
      when "FAQS_GET_CARD"
        # save response text => from bot to client
        client = Client.where(sender_id: @user_id).first
        Message.create(message: response_text, client_id: client.id, bot: true)
        # send message
        request_base(Messenger::Elements::Text.new(text: response_text))

      when "FAQS_OPEN_ACCOUNT"
        response = "¿Juridico ó Natural?"
        client = Client.where(sender_id: @user_id).first
        Message.create(message: response, client_id: client.id, bot: true)
        request_base(Messenger::Templates::Buttons.new(
            text: response_text,
            buttons: [
                Messenger::Elements::Button.new(type: 'postback', title: 'Juridico', value: 'FAQS_OPEN_ACCOUNT_JURIDICO'),
                Messenger::Elements::Button.new(type: 'postback', title: 'Natural', value: 'FAQS_OPEN_ACCOUNT_NATURAL')
            ]
        ))
      # save response text => from bot to client

      when "EXCHANGE_RATE"
        exchange = ExchangeRate.first
        request_base(Messenger::Elements::Text.new(text: response_text))
        response = "Dolar Venta: " + exchange.buy.to_s
        response += "\u000A Dolar Compra: " + exchange.sell.to_s
        response += "\u000A UFV: " + exchange.ufv.to_s

        client = Client.where(sender_id: @user_id).first
        Message.create(message: response, client_id: client.id, bot: true)

        request_base(Messenger::Elements::Text.new(text: response.encode('utf-8')))

      when "FAQS_BNBNET_ACCESS"
        response = "Los pasos para la apertura de la cuenta son: (Elementos enviados a messenger)"
        client = Client.where(sender_id: @user_id).first
        Message.create(message: response, client_id: client.id, bot: true)

        request_base(Messenger::Elements::Text.new(text: response_text))

        bubble1 = bubble_base('Ingrese la siguiente pagina', 'Vaya a la parte superior derecha',
                              request.base_url.to_s+'/assets/primero_paso.png')
        bubble2 = bubble_base('Click en la imagen BNB NET', 'imagen ubicada al centro',
                              request.base_url.to_s+'/assets/segundo_paso.png')
        bubble3 = bubble_base('Ingrese su credencial otorgado por el banco', 'No olvidar el recaptcha!!.',
                              request.base_url.to_s+'/assets/tercer_paso.png')
        request_base(Messenger::Templates::Generic.new(elements: [bubble1, bubble2, bubble3]))
      when "FAQS_PAYMENTS_SERVICES"
        client = Client.where(sender_id: @user_id).first
        Message.create(message: response_text, client_id: client.id, bot: true)

        request_base(Messenger::Elements::Text.new(text: response_text))

        bubble1 = bubble_base_without_image('Telefonia', 'Viva, Tigo, Entel')
        bubble2 = bubble_base_without_image('Serv. Basicos', 'Cre, Saguapac')
        bubble3 = bubble_base_without_image('Seguros', 'Boliviana y Vitalicia')
        request_base(Messenger::Templates::Generic.new(elements: [bubble1, bubble2, bubble3]))

      when "SMALLER_QUEUE"
        offices = Office.limit(3).order('quantity_of_people ASC')
        response = ""
        offices.each do |office|
          response += office.name + " : " + office.localization + " : " + office.quantity_of_people.to_s + " personas.\u000A"
        end
        client = Client.where(sender_id: @user_id).first
        Message.create(message: response, client_id: client.id, bot: true)
        request_base(Messenger::Elements::Text.new(text: response.encode('utf-8')))

      when "STATUS_OF_PROCEDURES"
        request_base(Messenger::Elements::Text.new(text: response_text))
      when "ID_PROCT"
        client = Client.find_by(sender_id:@user_id)
        credit_status=client.credit_status
        request_base(Messenger::Elements::Text.new(text: response_text))
        request_base(Messenger::Elements::Text.new(text: credit_status.description))
        #el nro de documento
      when "SEE_BALANCE"
        # verificar si esta logueado
        if self.middleware_login
          request_base(Messenger::Elements::Text.new(text: response_text+": Bs"+@client.balance.to_s))
        else
          body_request={
              :recipient => {:id => @user_id},
              "message" => {
                  "attachment" => {
                      "type" => "template",
                      "payload" => {
                          "template_type" => "generic",
                          "elements" => [{
                                             "title" => "Bienvenido al BNB",
                                             "image_url" => "http://boliviaemprende.com/wp-content/uploads/2015/03/banconacionaldeboliviaBNB.jpg",
                                             "buttons" => [{
                                                               "type": "account_link",
                                                               "url": "https://test-json-facebook.herokuapp.com/authorize"
                                                           }]
                                         }]
                      }
                  }
              }
          }
          header_request={
              "Content-Type" => "application/json"
          }
          url="https://graph.facebook.com/v2.6/me/messages?access_token="+Messenger.config.page_access_token
          create_request(url, body_request, header_request)
        end
    end
  end

  def clasify_postback(command)
    case command
      when "FAQS_OPEN_ACCOUNT_NATURAL"
        response_text = "Solo Necesitas llevar tu carnet de identidad."
        client = Client.where(sender_id: @user_id).first
        Message.create(message: response_text, client_id: client.id, bot: true)
        request_base(Messenger::Elements::Text.new(text: response_text))
      when "FAQS_OPEN_ACCOUNT_JURIDICO"
        response_text = "Necesitas Documento legal de la empresa y representantes."
        client = Client.where(sender_id: @user_id).first
        Message.create(message: response_text, client_id: client.id, bot: true)
        request_base(Messenger::Elements::Text.new(text: "Necesitas Documento legal de la empresa y representantes."))
      when "FAQS"
        response_text = "Preguntas Frecuentes"
        client = Client.where(sender_id: @user_id).first
        Message.create(message: response_text, client_id: client.id, bot: true)
        body_request={
            :recipient => {:id => @user_id},
            :message => {
                :text => "Seleccione una pregunta",
                "quick_replies": [
                    {
                        "content_type" => "text",
                        "title" => "Como entro a bnb.net?",
                        "payload" => "DEVELOPER_DEFINED_PAYLOAD_FOR_PICKING_RED",
                    },
                    {
                        "content_type" => "text",
                        "title" => "Perdi mi tarjeta que hago ?",
                        "payload" => "DEVELOPER_DEFINED_PAYLOAD_FOR_PICKING_GREEN",
                    },
                    {
                        "content_type" => "text",
                        "title" => "Quiero aperturar una cuenta",
                        "payload" => "DEVELOPER_DEFINED_PAYLOAD_FOR_PICKING_GREEN",
                    },
                    {
                        "content_type" => "text",
                        "title" => "Que servicios puedo pagar en el banco ?",
                        "payload" => "DEVELOPER_DEFINED_PAYLOAD_FOR_PICKING_GREEN",
                    }
                ]
            }
        }
        header_request={
            "Content-Type" => "application/json"
        }
        url="https://graph.facebook.com/v2.6/me/messages?access_token="+Messenger.config.page_access_token
        create_request(url, body_request, header_request)

      when "LOGIN"
        body_request={
            :recipient => {:id => @user_id},
            "message" => {
                "attachment" => {
                    "type" => "template",
                    "payload" => {
                        "template_type" => "generic",
                        "elements" => [{
                                           "title" => "Bienvenido al BNB",
                                           "image_url" => "http://boliviaemprende.com/wp-content/uploads/2015/03/banconacionaldeboliviaBNB.jpg",
                                           "buttons" => [{
                                                             "type": "account_link",
                                                             "url": "https://test-json-facebook.herokuapp.com/authorize"
                                                         }]
                                       }]
                    }
                }
            }
        }
        header_request={
            "Content-Type" => "application/json"
        }
        url="https://graph.facebook.com/v2.6/me/messages?access_token="+Messenger.config.page_access_token
        create_request(url, body_request, header_request)
      when "LOGOUT"
        body_request={
            :recipient => {:id => @user_id},
            "message" => {
                "attachment" => {
                    "type" => "template",
                    "payload" => {
                        "template_type" => "generic",
                        "elements" => [{
                                           "title" => "Bienvenido al BNB",
                                           "image_url" => "http://boliviaemprende.com/wp-content/uploads/2015/03/banconacionaldeboliviaBNB.jpg",
                                           "buttons" => [{
                                                             "type": "account_unlink",
                                                         }]
                                       }]
                    }
                }
            }
        }
        header_request={
            "Content-Type" => "application/json"
        }
        url="https://graph.facebook.com/v2.6/me/messages?access_token="+Messenger.config.page_access_token
        create_request(url, body_request, header_request)

      when "INFORMATION"
        body_request={
            :recipient => {:id => @user_id},
            :message => {
                :text => "Seleccione una opcion",
                "quick_replies": [
                    {
                        "content_type" => "text",
                        "title" => "Informacion de Tramites",
                        "payload" => "STATUS_OF_PROCEDURES",
                    },
                    {
                        "content_type" => "text",
                        "title" => "Sucursal menos vacia",
                        "payload" => "SMALLER_QUEUE",
                    },
                    {
                        "content_type" => "text",
                        "title" => "Ver mi saldo",
                        "payload" => "SEE_BALANCE", #NO OLVIDARSE MIDDLEWARE LOGIN
                    }
                ]
            }
        }
        header_request={
            "Content-Type" => "application/json"
        }
        url="https://graph.facebook.com/v2.6/me/messages?access_token="+Messenger.config.page_access_token
        create_request(url, body_request, header_request)

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

  def bubble_base(title, subtitle, url_image)
    bubble = Messenger::Elements::Bubble.new(
        title: title,
        subtitle: subtitle,
        image_url: url_image,
    )
  end

  def bubble_base_without_image(title, subtitle)
    bubble = Messenger::Elements::Bubble.new(
        title: title,
        subtitle: subtitle
    )
  end

  def create_request(url, hash_body, headers)
    HTTParty.post(url,
                  :body => hash_body.to_json,
                  :headers => headers)
  end

  def f x
    x.is_a?(Hash) ? x.inject({}) do |m, (k, v)|
      m[k] = f v unless k == 'quick_reply'
      m
    end : x
  end

  def login_or_log_out(account_linked)
    client=Client.find_by(sender_id: @user_id)
    client.logged
    if account_linked.status=="unlinked"
      #change attribute logger to 0
      client.logged=false
      client.save!
    else
      #change attribute logger to 1
      client.logged=true
      client.save!
    end
  end

  def middleware_login
    @client=Client.find_by(sender_id: @user_id)
    @client.logged
  end

end
