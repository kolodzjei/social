require "rails_helper"

RSpec.describe Notifications::ReplyNotifier, type: :service do
  describe "#notify" do
    subject(:notify) { described_class.new(actor, reply).notify }

    let(:actor) { create(:user) }
    
    context "when actor is the comment owner" do
      let(:reply) { create(:reply, comment: create(:comment, post: create(:post, user: create(:user)), user: actor), user: actor) }

      it "does not create a notification" do
        expect { notify }.not_to change(Notification, :count)
      end
    end

    context "when actor is not the comment owner" do
      let(:reply) { create(:reply, comment: create(:comment, post: create(:post, user: create(:user)) ,user: create(:user)), user: actor) }

      context "and notification already exists" do
        before do
          notify
        end

        it "does not create a notification" do
          expect { notify }.not_to change(Notification, :count)
        end
      end

      context "and notification does not exist" do
        it "creates a notification" do
          expect { notify }.to change(Notification, :count).by(1)
        end
      end
    end
  end
end