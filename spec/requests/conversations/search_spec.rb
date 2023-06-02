# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Conversations::Search", type: :request) do
  describe "GET /conversations/search" do
    context "when user is not logged in" do
      it "redirects to the login page" do
        get search_conversations_path
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context "when user is logged in" do
      it "returns json" do
        sign_in create(:user)
        get search_conversations_path, xhr: true
        expect(response.content_type).to(eq("application/json; charset=utf-8"))
      end
    end
  end
end
