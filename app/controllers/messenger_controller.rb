class MessengerController < Messenger::MessengerController
  def webhook
    #logic here
    # text=params[:entry].first["messaging"].first["message"][:text]
    fb_params.entries.each do |entry|
      entry.messagings.each do |messaging|
        if messaging.callback.message?
          # profile= Messenger::Client.get_user_profile(messaging.sender_id)
          # Messenger::Client.send(
          #     Messenger::Request.new(
          #         Messenger::Elements::Text.new(text: "#{messaging.callback.text}"),
          #         messaging.sender_id
          #     )
          # )
          client = ApiAiRuby::Client.new(:client_access_token => '5d8413c5badb49b4969a6e70a9d65edb')
          response = client.text_request messaging.callback.text
          response_api_ai_text= response[:result][:fulfillment][:speech]
          puts response_api_ai_text
          Messenger::Client.send(
              Messenger::Request.new(
                  Messenger::Elements::Text.new(text: "#{response_api_ai_text}"),
                  messaging.sender_id
              )
          )
          # puts messaging.callback.text
        end
      end
    end
    render nothing: true, status: 200
  end
end
