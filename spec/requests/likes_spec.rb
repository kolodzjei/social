require "rails_helper"

RSpec.describe("Likes", type: :request) do
  describe "POST /like" do
    context "when user is not logged in" do
      it "redirects to login page" do
        post like_path
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }

      before { sign_in(user) }

      context "and likeable exists" do
        let(:test_post) { create(:post, user: create(:user)) }


        it "likes the likeable" do
          post like_path, params: { likeable_type: "Post", likeable_id: test_post.id }
          expect(test_post.liked_by?(user)).to(be(true))
        end

        it "sends a notification" do
          expect_any_instance_of(LikeNotifier).to(receive(:notify))
          post like_path, params: { likeable_type: "Post", likeable_id: test_post.id }
        end
      end

      context "and likeable does not exist" do
        it "redirects to root path" do
          post like_path, params: { likeable_type: "Post", likeable_id: 0 }
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end

  describe "DELETE /like" do
    context "when user is not logged in" do
      it "redirects to login page" do
        delete like_path
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }

      before { sign_in(user) }

      context "and likeable exists" do
        let(:test_post) { create(:post, user: create(:user)) }

        context "and user has not liked the likeable" do
          it "doesn't change the like count" do
            expect do
              delete like_path, params: { likeable_type: "Post", likeable_id: test_post.id }
            end.to(change { test_post.likes.count }.by(0))
          end
        end

        context "and user has liked the post" do
          before { test_post.like(user) }

          it "unlikes the likeable" do
            expect(test_post.liked_by?(user)).to(be(true))
            delete like_path, params: { likeable_type: "Post", likeable_id: test_post.id }
            expect(test_post.liked_by?(user)).to(be(false))
          end
        end
      end

      context "when likeable does not exist" do
        it "redirects to root path" do
          delete like_path, params: { likeable_type: "Post", likeable_id: 0 }
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end
end