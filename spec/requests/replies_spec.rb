# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Replies", type: :request) do
  describe "GET /replies/:id" do
    context "when user is not logged in" do
      it "redirects to login page" do
        get reply_path(1)
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }
      before do
        sign_in(user)
      end

      context "and reply exists" do
        it "returns http success" do
          reply = create(:reply, user: user, comment: create(:comment, user: user, post: create(:post, user: user)))
          get reply_path(reply)
          expect(response).to(have_http_status(:success))
        end
      end

      context "and reply does not exist" do
        it "redirects to root" do
          get reply_path(1)
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end

  describe "POST /replies" do
    context "when user is not logged in" do
      it "redirects to login page" do
        post replies_path
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }
      before do
        sign_in(user)
      end

      context "and reply is valid" do
        it "creates a reply" do
          expect do
            post(
              replies_path,
              params: {
                reply: {
                  content: "Hello",
                  comment_id: create(:comment, user: user, post: create(:post, user: user)).id,
                },
              },
            )
          end.to(change(Reply, :count).by(1))
        end
      end

      context "and reply is invalid" do
        it "does not create a reply" do
          expect do
            post(
              replies_path,
              params: {
                reply: {
                  content: "",
                  comment_id: create(:comment, user: user, post: create(:post, user: user)).id,
                },
              },
            )
          end.to_not(change(Reply, :count))
        end
      end
    end
  end

  describe "DELETE /replies/:id" do
    context "when user is not logged in" do
      it "redirects to login page" do
        delete reply_path(1)
        expect(response).to(redirect_to(new_user_session_path))
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }
      before do
        sign_in(user)
      end

      context "and reply exists" do
        let(:reply) do
          create(:reply, comment: create(:comment, post: create(:post, user: user), user: user), user: user)
        end
        before do
          reply
        end

        context "and reply belongs to user" do
          it "deletes the reply" do
            expect do
              delete(reply_path(reply))
            end.to(change(Reply, :count).by(-1))
          end
        end

        context "and reply does not belong to user" do
          before do
            reply.update(user: create(:user))
          end

          it "does not delete the reply" do
            expect do
              delete(reply_path(reply))
            end.to_not(change(Reply, :count))
          end
        end
      end

      context "and reply does not exist" do
        it "redirects to root" do
          delete reply_path(1)
          expect(response).to(redirect_to(root_path))
        end
      end
    end
  end
end
