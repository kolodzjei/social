# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Notifications::CommentNotifier, type: :service) do
  describe "#notify" do
    subject(:notify) { described_class.new(actor, comment).notify }

    let(:actor) { create(:user) }

    context "when actor is the post owner" do
      let(:comment) { create(:comment, post: create(:post, user: actor), user: actor) }

      it "does not create a notification" do
        expect { notify }.not_to(change(Notification, :count))
      end
    end

    context "when actor is not the post owner" do
      let(:comment) { create(:comment, post: create(:post, user: create(:user)), user: actor) }

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
