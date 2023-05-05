# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def display_name(user)
    user.display_name || user.email.split("@").first
  end
end
