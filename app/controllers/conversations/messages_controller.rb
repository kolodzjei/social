# frozen_string_literal: true

module Conversations
  class MessagesController < ApplicationController
    before_action :authenticate_user!

    def create
      @conversation = current_user.conversations.find_by(id: params[:conversation_id])
      @message = @conversation.messages.build(message_params.merge(user: current_user))
      @message.save

      # if @message.save
      #   redirect_to(conversation_messages_path(@conversation))
      # else
      #   redirect_to(conversation_messages_path(@conversation), alert: @message.errors.full_messages.to_sentence)
      # end
    end

    private

    def message_params
      params.require(:message).permit(:content)
    end
  end
end
