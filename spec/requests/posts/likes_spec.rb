# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Posts::Likes", type: :request) do
  let(:user) { create(:user) }
  let(:test_post) { create(:post, user: user) }

  describe "POST /posts/:post_id/likes" do
    context "when user is not authenticated" do
      before do
        post post_likes_path(test_post)
      end

      it "redirects to login page" do
        expect(response).to(redirect_to(new_user_session_path))
      end

      it "does not create a like" do
        expect(test_post.likes.count).to(eq(0))
      end
    end

    context "when user is authenticated" do
      before do
        sign_in(user)
      end

      context "and post exists" do
        context "and user has not liked the post" do
          it "creates a like" do
            expect do
              post(post_likes_path(test_post))
            end.to(change(test_post.likes, :count).by(1))
          end

          it "enqueues a job to send a notification" do
            expect do
              post(post_likes_path(test_post))
            end.to(change(Notifications::LikeNotifierJob.jobs, :size).by(1))
          end
        end
      end

      context "and user has already liked the post" do
        before do
          test_post.like(user)
        end

        it "does not create a like" do
          expect do
            post(post_likes_path(test_post))
          end.to_not(change(test_post.likes, :count))
        end
      end

      context "and post does not exist" do
        it "redirects to root path" do
          post post_likes_path(0)
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end

  describe "DELETE /posts/:post_id/likes" do
    context "when user is not authenticated" do
      it "redirects to login page" do
        delete post_likes_path(test_post)
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context "when user is authenticated" do
      before do
        sign_in(user)
      end

      context "and post exists" do
        context "and user has already liked the post" do
          before do
            create(:like, likeable: test_post, user: user)
          end

          it "deletes the like" do
            expect do
              delete(post_likes_path(test_post))
            end.to(change(test_post.likes, :count).by(-1))
          end
        end

        context "and user has not liked the comment" do
          it "does not delete a like" do
            expect do
              delete(post_likes_path(test_post))
            end.to_not(change(test_post.likes, :count))
          end
        end
      end

      context "and post does not exist" do
        it "redirects to root path" do
          delete post_likes_path(0)
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end
end
