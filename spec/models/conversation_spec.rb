# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Conversation, type: :model) do
  describe "associations" do
    it { should belong_to(:sender).class_name("User") }
    it { should belong_to(:recipient).class_name("User") }
    it { should have_many(:messages).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:sender) }
    it { should validate_presence_of(:recipient) }
  end

  describe "scopes" do
    describe ".involving" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }

      context "when user is the sender" do
        let(:conversation) { create(:conversation, sender: user, recipient: other_user) }
        
        it "returns conversations" do
          expect(Conversation.involving(user)).to include(conversation)
        end
      end

      context "when user is the recipient" do
        let(:conversation) { create(:conversation, sender: other_user, recipient: user) }

        it "returns conversations where the user is the recipient" do
          expect(Conversation.involving(user)).to include(conversation)
        end
      end

      context "when user is not the sender or recipient" do
        let(:conversation) { create(:conversation, sender: other_user, recipient: create(:user)) }

        it "does not return conversations" do
          expect(Conversation.involving(user)).to_not include(conversation)
        end
      end
    end

    describe ".newest" do
      let!(:conversation1) { create(:conversation, sender: create(:user), recipient: create(:user), updated_at: 1.day.ago) }
      let!(:conversation2) { create(:conversation, sender: create(:user), recipient: create(:user), updated_at: Time.now) }

      it "returns conversations in descending order by updated_at" do
        expect(Conversation.newest).to eq([conversation2, conversation1])
      end
    end

    describe ".not_empty" do
      let (:user) { create(:user) }
      let (:other_user) { create(:user) }
      let!(:conversation) { create(:conversation, sender: user, recipient: other_user) }

      context "when conversation has messages" do
        before do
          create(:message, user: user, conversation: conversation)
        end

        it "returns conversations with messages" do
          expect(Conversation.not_empty).to include(conversation)
        end
      end

      context "when conversation does not have messages" do
        it "does not return conversations" do
          expect(Conversation.not_empty).to_not include(conversation)
        end
      end
    end
  end
end
