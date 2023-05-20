# frozen_string_literal: true

class RepliesController < ApplicationController
  before_action :authenticate_user!

  def show
    @reply = Reply.includes(:user, :replies, :rich_text_content, :likes, :likers).find_by(id: params[:id])
    return redirect_to(root_path) unless @reply

    @comment = @reply.comment
    @pagy, @replies = pagy(
      @reply.replies.includes(:rich_text_content, :likes, :likers, :replies, :user).newest,
      items: 10,
    )
  end

  def create
    @reply = Reply.new(reply_params)
    @reply.user = current_user

    if @reply.save
      send_notification
      flash[:success] = "Reply was successfully created."
    else
      flash[:error] = "There was an error creating your reply."
    end
    redirect
  end

  def destroy
    @reply = Reply.find_by(id: params[:id])
    if @reply&.user == current_user
      @reply.destroy
      flash[:success] = "Reply was successfully deleted."
    else
      flash[:error] = "There was an error deleting your reply."
    end
    redirect
  end

  private

  def reply_params
    params.require(:reply).permit(:content, :parent_reply_id, :comment_id)
  end

  def redirect
    if @reply
      if @reply.has_parent?
        redirect_to(@reply.parent_reply)
      else
        redirect_to(@reply.comment)
      end
    else
      redirect_to(root_path)
    end
  end

  def send_notification
    ReplyNotifier.new(current_user, @reply).notify
  end
end
