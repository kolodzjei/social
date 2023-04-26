# frozen_string_literal: true

class RepliesController < ApplicationController
  before_action :authenticate_user!

  def create
    @reply = Reply.new(reply_params)
    @reply.user = current_user
    
    if @reply.save
      flash[:success] = "Reply was successfully created."
    else
      flash[:error] = "There was an error creating your reply."
    end

    redirect_to(@reply.comment)
  end

  private

  def reply_params
    params.require(:reply).permit(:content, :parent_reply_id, :comment_id)
  end
end
