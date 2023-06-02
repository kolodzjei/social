require "rails_helper"

RSpec.describe "Conversations", type: :request do
  describe "GET /conversations" do
    context "when user is not logged in" do
      it "redirects to the login page" do
        get conversations_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      it "returns http success" do
        sign_in create(:user)
        get conversations_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /conversations/:id" do
    context "when user is not logged in" do
      it "redirects to the login page" do
        get conversation_path(1)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }

      before do
        sign_in user
      end
      
      context "when user is not a participant of the conversation" do
        let(:conversation) { create(:conversation, recipient: create(:user), sender: create(:user)) }

        it "redirects to the conversations page" do
          get conversation_path(conversation)
          expect(response).to redirect_to(conversations_path)
        end
      end

      context "when user is a participant of the conversation" do
        context "when user is the sender of the conversation" do
          let(:conversation) { create(:conversation, sender: user, recipient: create(:user)) }

          it "returns http success" do
            get conversation_path(conversation)
            expect(response).to have_http_status(:success)
          end
        end

        context "when user is the recipient of the conversation" do
          let(:conversation) { create(:conversation, recipient: user, sender: create(:user)) }

          it "returns http success" do
            get conversation_path(conversation)
            expect(response).to have_http_status(:success)
          end
        end
      end

      context "when conversation does not exist" do
        it "redirects to the conversations page" do
          get conversation_path(0)
          expect(response).to redirect_to(conversations_path)
        end
      end
    end
  end

  describe "POST /conversations" do
    context "when user is not logged in" do
      it "redirects to the login page" do
        post conversations_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      context "when user is trying to start a conversation with themselves" do
        it "redirects to the conversations page" do
          post conversations_path, params: { user_id: user.id }
          expect(response).to redirect_to(conversations_path)
        end
      end

      context "when user is trying to start a conversation with another user" do
        let(:other_user) { create(:user) }

        context "when conversation already exists" do
          before do
            other_user.update!(id: user.id + 1)
            @conversation = create(:conversation, sender: user, recipient: other_user)
          end

          it "redirects to the existing conversation" do
            expect {
              post conversations_path, params: { user_id: other_user.id }
            }.to_not change(Conversation, :count)

            expect(response).to redirect_to(conversation_path(@conversation))
          end
        end

        context "when conversation does not exist" do
          it "creates a new conversation" do
            expect {
              post conversations_path, params: { user_id: other_user.id }
            }.to change(Conversation, :count).by(1)
          end

          it "redirects to the new conversation" do
            post conversations_path, params: { user_id: other_user.id }
            expect(response).to redirect_to(conversation_path(Conversation.last))
          end
        end
      end
    end
  end
end