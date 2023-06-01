class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, @notifications = pagy(current_user.notifications.latest.includes(:actor, :target), items: 25)
  end
end