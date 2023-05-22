# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Posts", type: :request) do
  describe("GET /posts/:id") do
    context("when user is not logged in") do
      it "redirects to the signin path" do
        get post_path(1)
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context("when user is logged in") do
      let(:user) { create(:user) }
      before(:each) do
        sign_in(user)
      end

      context("and post exists") do
        let(:test_post) { create(:post, user: user) }

        it "returns http success" do
          get post_path(test_post)
          expect(response).to(have_http_status(:success))
        end
      end

      context("and post does not exist") do
        it "redirects to the root path" do
          get post_path(1)
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end

  describe("POST /posts") do
    context("when user is not logged in") do
      it "redirects to the signin path" do
        post posts_path
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context("when user is logged in") do
      let(:user) { create(:user) }
      before(:each) do
        sign_in(user)
      end

      context("and post is valid") do
        it "creates a post" do
          expect do
            post(posts_path, params: { post: { content: "Hello, world!" } })
          end.to(change { Post.count }.by(1))
          expect(response).to(redirect_to(root_path))
        end

        it "creates a notification" do
          allow_any_instance_of(Notifications::PostNotifier).to(receive(:notify_followers))
          post(posts_path, params: { post: { content: "Hello, world!" } })
        end
      end

      context("and post is invalid") do
        it "does not create a post" do
          expect do
            post(posts_path, params: { post: { content: "" } })
          end.not_to(change { Post.count })
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end

  describe("DELETE /posts/:id") do
    context("when user is not logged in") do
      it "redirects to the signin path" do
        delete post_path(1)
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context("when user is logged in") do
      let(:user) { create(:user) }
      before(:each) do
        sign_in(user)
      end

      context("and post exists") do
        context("and user is the author of the post") do
          let(:test_post) { create(:post, user: user) }

          it "deletes the post" do
            test_post
            expect do
              delete(post_path(test_post))
            end.to(change { Post.count }.by(-1))
            expect(response).to(redirect_to(root_path))
          end
        end

        context("and user is not the author of the post") do
          let(:other_user) { create(:user) }
          let(:test_post) { create(:post, user: other_user) }

          it "does not delete the post" do
            test_post
            expect do
              delete(post_path(test_post))
            end.not_to(change { Post.count })
            expect(response).to(redirect_to(root_path))
          end
        end
      end

      context("and post does not exist") do
        it "redirects to the root path" do
          delete post_path(1)
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end
end
