# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Message, type: :model) do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:conversation) }
  end

  describe "validations" do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:conversation) }
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_most(500) }
  end

  describe "callbacks" do
    describe "after_create_commit" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let(:conversation) { create(:conversation, sender: user, recipient: other_user) }
      let(:message) { build(:message, conversation: conversation, user: user) }

      it "broadcasts to the conversation" do
        expect(message).to receive(:broadcast_append_to).with("conversation-#{conversation.id}")
        message.save
      end

      it "updates the conversation's updated_at" do
        expect { message.save }.to change { conversation.reload.updated_at }
      end
    end
  end
end
