require "rails_helper"

RSpec.describe(Notifications::MessageNotifierJob, type: :job) do
  describe "#perform" do
    let(:sender) { create(:user) }
    let(:recipient) { create(:user) }
    let(:conversation) { create(:conversation, sender: sender, recipient: recipient) }
    let(:args) { { "actor_id" => sender.id, "conversation_id" => conversation.id } }

    it "calls MessageNotifier#notify" do
      expect_any_instance_of(Notifications::MessageNotifier).to(receive(:notify))
      described_class.new.perform(args)
    end

    context "when actor or conversation is not found" do
      it "does not call MessageNotifier#notify" do
        expect_any_instance_of(Notifications::MessageNotifier).not_to(receive(:notify))
        described_class.new.perform({ "actor_id" => 0, "conversation_id" => conversation.id })
        described_class.new.perform({ "actor_id" => sender.id, "conversation_id" => 0 })
      end
    end
  end
end