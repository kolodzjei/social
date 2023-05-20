# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Users", type: :request) do
  describe "GET /users/:id" do
    context "when user is not logged in" do
      it "redirects to login page" do
        get user_path(1)
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }

      before { sign_in(user) }

      context "and user exists" do
        let(:test_user) { create(:user) }

        it "returns http success" do
          get user_path(test_user)
          expect(response).to(have_http_status(:success))
        end
      end

      context "and user does not exist" do
        it "redirects to root path" do
          get user_path(0)
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end

  describe "GET /users/:id/followers" do
    context "when user is not logged in" do
      it "redirects to login page" do
        get followers_user_path(1)
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }

      before { sign_in(user) }

      context "and user exists" do
        let(:test_user) { create(:user) }

        it "returns http success" do
          get followers_user_path(test_user)
          expect(response).to(have_http_status(:success))
        end
      end

      context "and user does not exist" do
        it "redirects to root path" do
          get followers_user_path(0)
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end

  describe "GET /users/:id/following" do
    context "when user is not logged in" do
      it "redirects to login page" do
        get following_user_path(1)
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }

      before { sign_in(user) }

      context "and user exists" do
        let(:test_user) { create(:user) }

        it "returns http success" do
          get following_user_path(test_user)
          expect(response).to(have_http_status(:success))
        end
      end

      context "and user does not exist" do
        it "redirects to root path" do
          get following_user_path(0)
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end
end
