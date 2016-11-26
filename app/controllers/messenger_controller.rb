class MessengerController < Messenger::MessengerController
  def webhook
    # text=params[:entry].first["messaging"].first["message"][:text]
    params[:entry].first[:messaging].first[:message].delete :quick_reply
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
      command_response= model_response[:result][:action] # accion
      message_response= model_response[:result][:fulfillment][:speech] #respuesta
      clasify_messagin(command_response, message_response)
    end

    unless message.attachments.nil?
      puts message.attachments
    end
  end

  def receive_postback(command)
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
      when "FAQS_GET_CARD"
        request_base(Messenger::Elements::Text.new(text: response_text))
      when "FAQS_OPEN_ACCOUNT"
        request_base(Messenger::Templates::Buttons.new(
            text: response_text,
            buttons: [
                Messenger::Elements::Button.new(type: 'postback', title: 'Juridico', value: 'FAQS_OPEN_ACCOUNT_JURIDICO'),
                Messenger::Elements::Button.new(type: 'postback', title: 'Natural', value: 'FAQS_OPEN_ACCOUNT_NATURAL')
            ]
        ))
      when "EXCHANGE_RATE"
        exchange = ExchangeRate.first
        request_base(Messenger::Elements::Text.new(text: response_text))
        response = "Dolar Venta: " + exchange.buy.to_s
        response += "\u000A Dolar Compra: " + exchange.sell.to_s
        response += "\u000A UFV: " + exchange.ufv.to_s
        request_base(Messenger::Elements::Text.new(text: response.encode('utf-8')))

      when "FAQS_BNBNET_ACCESS"
        request_base(Messenger::Elements::Text.new(text: response_text))

        bubble1 = bubble_base('Ingrese la siguiente pagina', 'Vaya a la parte superior derecha',
                              request.base_url.to_s+'/assets/primero_paso.png')
        bubble2 = bubble_base('Click en la imagen BNB NET', 'imagen ubicada al centro',
                              request.base_url.to_s+'/assets/segundo_paso.png')
        bubble3 = bubble_base('Ingrese su credencial otorgado por el banco', 'No olvidar el recaptcha!!.',
                              request.base_url.to_s+'/assets/tercer_paso.png')
        request_base(Messenger::Templates::Generic.new(elements:[bubble1,bubble2,bubble3]))
        when "FAQS_PAYMENTS_SERVICES"
        request_base(Messenger::Elements::Text.new(text: response_text))

        bubble1 = bubble_base_without_image('Telefonia', 'Viva, Tigo, Entel')
        bubble2 = bubble_base_without_image('Serv. Basicos', 'Cre, Saguapac')
        bubble3 = bubble_base_without_image('Seguros', 'Boliviana y Vitalicia')
        request_base(Messenger::Templates::Generic.new(elements:[bubble1,bubble2,bubble3]))

    end
  end
  def clasify_postback(command)
    case command
      when "FAQS_OPEN_ACCOUNT_NATURAL"
        request_base(Messenger::Elements::Text.new(text: "Solo Necesitas llevar tu carnet de identidad."))
      when "FAQS_OPEN_ACCOUNT_JURIDICO"
        request_base(Messenger::Elements::Text.new(text: "Necesitas Documento legal de la empresa y representantes."))
      when "FAQS"
        body_request={
            :recipient => {:id =>@user_id},
            :message=> {
                :text => "Seleccione una pregunta",
                "quick_replies":[
                    {
                        "content_type"=>"text",
                        "title"=>"Como entro a bnb.net?",
                        "payload"=>"DEVELOPER_DEFINED_PAYLOAD_FOR_PICKING_RED",
                    },
                    {
                        "content_type"=>"text",
                        "title"=>"Perdi mi tarjeta que hago ?",
                        "payload"=>"DEVELOPER_DEFINED_PAYLOAD_FOR_PICKING_GREEN",
                    },
                    {
                        "content_type"=>"text",
                        "title"=>"Quiero aperturar una cuenta",
                        "payload"=>"DEVELOPER_DEFINED_PAYLOAD_FOR_PICKING_GREEN",
                    },
                    {
                        "content_type"=>"text",
                        "title"=>"Que servicios puedo pagar en el banco ?",
                        "payload"=>"DEVELOPER_DEFINED_PAYLOAD_FOR_PICKING_GREEN",
                    }
                ]
            }
        }
        header_request={
            "Content-Type"=>"application/json"
        }
        url="https://graph.facebook.com/v2.6/me/messages?access_token="+Messenger.config.page_access_token
        create_request(url,body_request,header_request)

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
        image_url: url_image ,
    )
  end
  def bubble_base_without_image(title, subtitle)
    bubble = Messenger::Elements::Bubble.new(
        title: title,
        subtitle: subtitle
    )
  end

  def create_request(url,hash_body,headers)
    HTTParty.post(url,
                  :body => hash_body.to_json,
                  :headers => headers )
  end

  def f x
    x.is_a?(Hash) ? x.inject({}) do |m, (k, v)|
      m[k] = f v unless k == 'quick_reply'
      m
    end : x
  end

end
