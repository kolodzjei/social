# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Replies::Likes", type: :request) do
  let(:user) { create(:user) }
  let(:test_post) { create(:post, user: user) }
  let(:comment) { create(:comment, post: test_post, user: user) }
  let(:reply) { create(:reply, comment: comment, user: user) }

  describe "POST /replies/:reply_id/likes" do
    context "when user is not authenticated" do
      before do
        post reply_likes_path(reply)
      end

      it "redirects to login page" do
        expect(response).to(redirect_to(new_user_session_path))
      end

      it "does not create a like" do
        expect(reply.likes.count).to(eq(0))
      end
    end

    context "when user is authenticated" do
      before do
        sign_in(user)
      end

      context "and reply exists" do
        context "and user has not liked the reply" do
          it "creates a like" do
            expect do
              post(reply_likes_path(reply))
            end.to(change(reply.likes, :count).by(1))
          end

          it "sends a notification" do
            expect_any_instance_of(LikeNotifier).to(receive(:notify))
            post(reply_likes_path(reply))
          end
        end
      end

      context "and user has already liked the reply" do
        before do
          reply.like(user)
        end

        it "does not create a like" do
          expect do
            post(reply_likes_path(reply))
          end.to_not(change(reply.likes, :count))
        end
      end

      context "and reply does not exist" do
        it "redirects to root path" do
          post reply_likes_path(0)
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end

  describe "DELETE /comments/:comment_id/likes" do
    context "when user is not authenticated" do
      it "redirects to login page" do
        delete reply_likes_path(reply)
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context "when user is authenticated" do
      before do
        sign_in(user)
      end

      context "and reply exists" do
        context "and user has already liked the reply" do
          before do
            create(:like, likeable: reply, user: user)
          end

          it "deletes the like" do
            expect do
              delete(reply_likes_path(reply))
            end.to(change(reply.likes, :count).by(-1))
          end
        end

        context "and user has not liked the reply" do
          it "does not delete a like" do
            expect do
              delete(reply_likes_path(reply))
            end.to_not(change(reply.likes, :count))
          end
        end
      end

      context "and reply does not exist" do
        it "redirects to root path" do
          delete reply_likes_path(0)
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end
end
