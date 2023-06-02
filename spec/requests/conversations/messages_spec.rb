# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Conversations::Messages", type: :request) do
  describe "POST /conversations/:conversation_id/messages" do
    context "when user is not logged in" do
      it "redirects to the login page" do
        post conversation_messages_path(1)
        expect(response).to(redirect_to(new_user_session_path))
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
          post conversation_messages_path(conversation, params: { message: { content: "Hello" } })
          expect(response).to(redirect_to(conversations_path))
        end
      end

      context "when user is a participant of the conversation" do
        context "when user is the sender of the conversation" do
          let(:conversation) { create(:conversation, sender: user, recipient: create(:user)) }

          context "when the message is invalid" do
            it "redirects to the conversation page" do
              post conversation_messages_path(conversation, params: { message: { content: "" } })
              expect(response).to(redirect_to(conversation_path(conversation)))
            end

            it "does not create a new message" do
              expect do
                post(conversation_messages_path(conversation, params: { message: { content: "" } }))
              end.not_to(change { conversation.messages.count })
            end
          end

          context "when the message is valid" do
            it "creates a new message" do
              expect do
                post(conversation_messages_path(conversation, params: { message: { content: "Hello" } }))
              end.to(change { conversation.messages.count }.by(1))
            end
          end
        end

        context "when user is the recipient of the conversation" do
          let(:conversation) { create(:conversation, recipient: user, sender: create(:user)) }

          context "when the message is invalid" do
            it "redirects to the conversation page" do
              post conversation_messages_path(conversation, params: { message: { content: "" } })
              expect(response).to(redirect_to(conversation_path(conversation)))
            end

            it "does not create a new message" do
              expect do
                post(conversation_messages_path(conversation, params: { message: { content: "" } }))
              end.not_to(change { conversation.messages.count })
            end
          end

          context "when the message is valid" do
            it "creates a new message" do
              expect do
                post(conversation_messages_path(conversation, params: { message: { content: "Hello" } }))
              end.to(change { conversation.messages.count }.by(1))
            end
          end
        end
      end

      context "when the conversation doesnt exist" do
        it "redirects to the conversations page" do
          post conversation_messages_path(1, params: { message: { content: "Hello" } })
          expect(response).to(redirect_to(conversations_path))
        end
      end
    end
  end
end
