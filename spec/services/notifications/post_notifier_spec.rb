# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Notifications::PostNotifier, type: :service) do
  describe "#notify_followers" do
    subject(:notify_followers) { described_class.new(actor, post).notify_followers }

    let(:actor) { create(:user) }
    let(:post) { create(:post, user: actor) }

    context "when actor has no followers" do
      it "does not create a notification" do
        expect { notify_followers }.not_to(change(Notification, :count))
      end
    end

    context "when actor has followers" do
      let!(:follower) { create(:user).tap { |u| u.follow(actor) } }

      it "creates a notification for each follower" do
        expect { notify_followers }.to(change(Notification, :count).by(1))
      end
    end
  end
end
