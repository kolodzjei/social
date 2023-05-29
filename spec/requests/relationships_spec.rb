# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Relationships", type: :request) do
  describe "POST /follow" do
    context "when user is not logged in" do
      it "redirects to login page" do
        post follow_path
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }

      before { sign_in(user) }

      context "when other user exists" do
        let(:other_user) { create(:user) }

        it "follows the user" do
          post follow_path, params: { user_id: other_user.id }
          expect(user.following?(other_user)).to(be(true))
        end

        it "enqueues a job to send a notification" do
          expect do
            post follow_path, params: { user_id: other_user.id }
          end.to change(Notifications::FollowNotifierJob.jobs, :size).by(1)
        end
      end

      context "when other user does not exist" do
        it "redirects to root path" do
          post follow_path, params: { user_id: 0 }
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end

  describe "DELETE /unfollow" do
    context "when user is not logged in" do
      it "redirects to login page" do
        delete unfollow_path
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }

      before { sign_in(user) }

      context "when other user exists" do
        let(:other_user) { create(:user) }

        before { user.follow(other_user) }

        it "unfollows the user" do
          delete unfollow_path, params: { user_id: other_user.id }
          expect(user.following?(other_user)).to(be(false))
        end
      end

      context "when other user does not exist" do
        it "redirects to root path" do
          delete unfollow_path, params: { user_id: 0 }
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end
end
