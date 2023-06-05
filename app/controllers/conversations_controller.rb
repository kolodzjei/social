# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = Conversation.includes(:messages, :sender, :recipient).involving(current_user).newest.not_empty
  end

  def show
    @conversation = Conversation.find_by(id: params[:id])

    return redirect_to(conversations_path, alert: "Conversation not found.") unless @conversation

    if current_user == @conversation.sender || current_user == @conversation.recipient
      @pagy, @messages = pagy(@conversation.messages.includes(:user).order(created_at: :desc), items: 10)
      @messages = @messages.reverse
      @message = Message.new
    else
      redirect_to(conversations_path, alert: "You don't have permission to view this conversation.")
    end
  end

  def create
    sender_id, recipient_id = normalize_ids(current_user.id, params[:user_id])

    return redirect_to(
      conversations_path,
      alert: "You can't start a conversation with yourself.",
    ) if sender_id == recipient_id

    @conversation = Conversation.find_or_initialize_by(
      sender_id: sender_id,
      recipient_id: recipient_id,
    )

    if @conversation.save
      redirect_to(conversation_path(@conversation))
    else
      redirect_to(root_path, alert: @conversation.errors.full_messages.to_sentence)
    end
  end

  private

  def normalize_ids(id1, id2)
    id1 = id1.to_i
    id2 = id2.to_i
    if id1 < id2
      [id1, id2]
    else
      [id2, id1]
    end
  end
end
