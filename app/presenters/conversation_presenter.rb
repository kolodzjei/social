# frozen_string_literal: true

class ConversationPresenter
  def initialize(conversation, current_user)
    @conversation = conversation
    @current_user = current_user
  end

  def user_avatar
    user.avatar
  end

  def user
    @user ||= current_user == conversation.sender ? conversation.recipient : conversation.sender
  end

  def last_message
    message.present? ? message.content : "--"
  end

  def last_message_time
    message.present? ? message.created_at : conversation.created_at
  end

  private

  attr_reader :conversation, :current_user

  def message
    @message ||= conversation.messages.last
  end
end
