# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Comments::Likes", type: :request) do
  let(:user) { create(:user) }
  let(:test_post) { create(:post, user: user) }
  let(:comment) { create(:comment, post: test_post, user: user) }

  describe "POST /comments/:comment_id/likes" do
    context "when user is not authenticated" do
      before do
        post comment_likes_path(comment)
      end

      it "redirects to login page" do
        expect(response).to(redirect_to(new_user_session_path))
      end

      it "does not create a like" do
        expect(comment.likes.count).to(eq(0))
      end
    end

    context "when user is authenticated" do
      before do
        sign_in(user)
      end

      context "and comment exists" do
        context "and user has not liked the comment" do
          it "creates a like" do
            expect do
              post(comment_likes_path(comment))
            end.to(change(comment.likes, :count).by(1))
          end

          it "enqueues a job to send a notification" do
            expect do
              post(comment_likes_path(comment))
            end.to change(Notifications::LikeNotifierJob.jobs, :size).by(1)
          end
        end
      end

      context "and user has already liked the comment" do
        before do
          comment.like(user)
        end

        it "does not create a like" do
          expect do
            post(comment_likes_path(comment))
          end.to_not(change(comment.likes, :count))
        end
      end

      context "and comment does not exist" do
        it "redirects to root path" do
          post comment_likes_path(0)
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end

  describe "DELETE /comments/:comment_id/likes" do
    context "when user is not authenticated" do
      it "redirects to login page" do
        delete comment_likes_path(comment)
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context "when user is authenticated" do
      before do
        sign_in(user)
      end

      context "and comment exists" do
        context "and user has already liked the comment" do
          before do
            create(:like, likeable: comment, user: user)
          end

          it "deletes the like" do
            expect do
              delete(comment_likes_path(comment))
            end.to(change(comment.likes, :count).by(-1))
          end
        end

        context "and user has not liked the comment" do
          it "does not delete a like" do
            expect do
              delete(comment_likes_path(comment))
            end.to_not(change(comment.likes, :count))
          end
        end
      end

      context "and comment does not exist" do
        it "redirects to root path" do
          delete comment_likes_path(0)
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end
end
