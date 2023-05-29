# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Notifications::FollowNotifier, type: :service) do
  describe "#notify" do
    subject(:notify) { described_class.new(actor, user).notify }

    let(:actor) { create(:user) }

    context "when user is actor" do
      let(:user) { actor }

      it "does not create a notification" do
        expect { notify }.not_to(change(Notification, :count))
      end
    end

    context "when user is not actor" do
      let(:user) { create(:user) }

      context "when notification already exists" do
        before do
          notify
        end

        it "does not create a notification" do
          expect { notify }.not_to(change(Notification, :count))
        end
      end

      context "when notification does not exist" do
        it "creates a notification" do
          expect { notify }.to(change(Notification, :count).by(1))
        end
      end
    end
  end
end
