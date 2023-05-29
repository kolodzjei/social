# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Notifications::LikeNotifier, type: :service) do
  describe "#notify" do
    subject(:notify) { described_class.new(actor, likeable).notify }

    let(:actor) { create(:user) }

    context "when likeable is a post" do
      context "and actor is the post owner" do
        let(:likeable) { create(:post, user: actor) }

        it "does not create a notification" do
          expect { notify }.not_to(change(Notification, :count))
        end
      end

      context "and actor is not the post owner" do
        let(:likeable) { create(:post, user: create(:user)) }

        context "and notification already exists" do
          before do
            notify
          end

          it "does not create a notification" do
            expect { notify }.not_to(change(Notification, :count))
          end
        end

        context "and notification does not exist" do
          it "creates a notification" do
            expect { notify }.to(change(Notification, :count).by(1))
          end
        end
      end
    end

    context "when likeable is a comment" do
      context "and actor is the comment owner" do
        let(:likeable) { create(:comment, post: create(:post, user: create(:user)), user: actor) }

        it "does not create a notification" do
          expect { notify }.not_to(change(Notification, :count))
        end
      end

      context "and actor is not the comment owner" do
        let(:likeable) { create(:comment, post: create(:post, user: create(:user)), user: create(:user)) }

        context "and notification already exists" do
          before do
            notify
          end

          it "does not create a notification" do
            expect { notify }.not_to(change(Notification, :count))
          end
        end

        context "and notification does not exist" do
          it "creates a notification" do
            expect { notify }.to(change(Notification, :count).by(1))
          end
        end
      end
    end

    context "when likeable is a reply" do
      context "and actor is the reply owner" do
        let(:likeable) do
          create(
            :reply,
            comment: create(:comment, post: create(:post, user: create(:user)), user: create(:user)),
            user: actor,
          )
        end

        it "does not create a notification" do
          expect { notify }.not_to(change(Notification, :count))
        end
      end

      context "and actor is not the reply owner" do
        let(:likeable) do
          create(
            :reply,
            comment: create(:comment, post: create(:post, user: create(:user)), user: create(:user)),
            user: create(:user),
          )
        end

        context "and notification already exists" do
          before do
            notify
          end

          it "does not create a notification" do
            expect { notify }.not_to(change(Notification, :count))
          end
        end

        context "and notification does not exist" do
          it "creates a notification" do
            expect { notify }.to(change(Notification, :count).by(1))
          end
        end
      end
    end
  end
end
