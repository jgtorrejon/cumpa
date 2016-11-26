class MessengerController < Messenger::MessengerController
  def webhook
    #logic here
    # text=params[:entry].first["messaging"].first["message"][:text]
    fb_params.entries.each do |entry|
      process_response(entry)
    end
    render nothing: true, status: 200

  end

  def process_response(entry)
    entry.messagings.each do |messaging|
      if messaging.callback.message?
        puts "arrive message"
      elsif messaging.callback.delivery?
        puts "arrive delivery"
      elsif messaging.callback.postback?
        puts "arrive postback"
      elsif messaging.callback.optin?
        puts "arrive option"
      elsif messaging.callback.account_linking?
        puts "arrive acount_link"
      end
      # Messenger::Client.send(
      #     Messenger::Request.new(
      #         Messenger::Elements::Text.new(text: "Echo: #{messaging.callback.text}"),
      #         messaging.sender_id
      #     )
      # )

    end
  end
end
