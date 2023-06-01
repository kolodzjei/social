# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = Conversation.includes(:messages, :sender, :recipient).involving(current_user).newest.not_empty
  end

  def show
    @conversation = Conversation.find_by(id: params[:id])

    if current_user == @conversation.sender || current_user == @conversation.recipient
      @messages = @conversation.messages.includes(:user).order(created_at: :asc)
      @message = Message.new
    else
      redirect_to(root_path, alert: "You don't have permission to view this conversation.")
    end
  end

  def create
    sender_id, recipient_id = normalize_ids(current_user.id, params[:user_id])

    @conversation = Conversation.find_or_initialize_by(
      sender_id: sender_id,
      recipient_id: recipient_id,
    )

    if @conversation.save
      redirect_to(conversation_messages_path(@conversation))
    else
      redirect_to(root_path, alert: @conversation.errors.full_messages.to_sentence)
    end
  end

  private

  def normalize_ids(id1, id2)
    if id1 < id2
      [id1, id2]
    else
      [id2, id1]
    end
  end
end
