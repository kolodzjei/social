# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_notifications, if: :user_signed_in?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [])
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :display_name])
  end

  def load_notifications
    @notifications = Notification.includes(:actor).where(user: current_user).order(created_at: :desc).limit(6)
  end
end
