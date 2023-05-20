# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Comments", type: :request) do
  describe "GET /comments/:id" do
    context "when user is not logged in" do
      it "redirects to login page" do
        get comment_path(1)
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }
      before do
        sign_in(user)
      end

      context "and comment exists" do
        it "returns http success" do
          comment = create(:comment, user: user, post: create(:post, user: user))
          get comment_path(comment)
          expect(response).to(have_http_status(:success))
        end
      end

      context "and comment does not exist" do
        it "redirects to root" do
          get comment_path(1)
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end

  describe "POST /comments" do
    context "when user is not logged in" do
      it "redirects to login page" do
        post comments_path
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }
      before do
        sign_in(user)
      end

      context "and comment is valid" do
        it "creates a comment" do
          expect do
            post(comments_path, params: { comment: { content: "Hello", post_id: create(:post, user: user).id } })
          end.to(change(Comment, :count).by(1))
        end
      end

      context "and comment is invalid" do
        it "does not create a comment" do
          expect do
            post(comments_path, params: { comment: { content: "", post_id: create(:post, user: user).id } })
          end.to(change(Comment, :count).by(0))
        end
      end
    end
  end

  describe "DELETE /comments/:id" do
    context "when user is not logged in" do
      it "redirects to login page" do
        delete comment_path(1)
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }
      before do
        sign_in(user)
      end

      context "and comment exists" do
        let(:comment) { create(:comment, post: create(:post, user: user), user: create(:user)) }
        before do
          comment
        end

        context "and user is the owner of the comment" do
          before do
            comment.update(user: user)
          end

          it "deletes the comment" do
            expect do
              delete(comment_path(comment))
            end.to(change(Comment, :count).by(-1))
            expect(response).to(redirect_to(post_path(comment.post)))
          end
        end

        context "and user is not the owner of the comment" do
          it "does not delete the comment" do
            expect do
              delete(comment_path(comment))
            end.to(change(Comment, :count).by(0))
            expect(response).to(redirect_to(root_path))
          end
        end
      end

      context "and comment does not exist" do
        it "redirects to root" do
          expect do
            delete(comment_path(1))
          end.to(change(Comment, :count).by(0))
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end
end
