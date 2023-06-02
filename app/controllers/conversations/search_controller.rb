# frozen_string_literal: true

module Conversations
  class SearchController < ApplicationController
    before_action :authenticate_user!
  
    def index
      @users = User.where("display_name LIKE ?", "%#{params[:search]}%")

      respond_to do |format|
        format.json do
          render(json: render_to_string(partial: "conversations/user", collection: @users, as: :user, formats: [:html]))
        end
      end
    end
  end
end
