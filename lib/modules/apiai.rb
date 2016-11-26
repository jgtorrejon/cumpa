module Apiai
  # def parse_model(value_hash, auto_send=true)
  #
  #
  #   model_api_ai= Struct.new(response)
  #   if aut_send
  #     send_response(model_api_ai)
  #   end
  #   model_api_ai
  # end
  #
  # def send_response(model=nil)
    #   client = ApiAiRuby::Client.new(:client_access_token => self.ACCESS_TOKEN)
  #   response = client.text_request messaging.callback.text
  #   # response_api_ai_text= response[:result][:fulfillment][:speech]
  #   Messenger::Client.send(
  #       Messenger::Request.new(
  #           Messenger::Elements::Text.new(text: "#{model.try(:result).try(:fulfillment).try(:speech)}"),
  #           messaging.sender_id
  #       )
  #   )
  # end
  #
  # def ACCESS_TOKEN
  #   '5d8413c5badb49b4969a6e70a9d65edb' #todo new struct by joel
  # end


end