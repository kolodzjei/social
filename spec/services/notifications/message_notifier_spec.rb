require "rails_helper"

RSpec.describe Notifications::MessageNotifier do
  describe "#notify" do
    subject(:notify) { described_class.new(conversation, actor).notify }
    let(:actor) { create(:user) }
    let(:recipient) { create(:user) }
    let(:conversation) { create(:conversation, sender: actor, recipient: recipient) }
    
    context "when notification does not exist" do
      it "creates a notification" do
        expect { notify }.to(change(Notification, :count).by(1))
      end
    end

    context "when notification already exists" do
      before do
        create(:notification, user: recipient, target: conversation, actor: actor, content: "sent you a message.")
      end

      it "does not create a notification" do
        expect { notify }.not_to(change(Notification, :count))
      end

      it "updates the notification" do
        expect { notify }.to(change { Notification.last.updated_at })
      end
    end

  end
end