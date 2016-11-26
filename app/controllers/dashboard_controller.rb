class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :notification
  def index
  end

  def notification
    @count_notification = Client.where(:bot_service => false).count
  end
end
