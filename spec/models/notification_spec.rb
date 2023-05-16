# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Notification, type: :model) do
  context "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:target) }
    it { should belong_to(:actor) }
  end

  context "validations" do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:target) }
  end

  context "#message" do
    let(:user) { create(:user) }
    let(:actor) { create(:user) }
    let(:post) { create(:post, user: user) }
    let(:notification) { create(:notification, user: user, actor: actor, target: post) }

    describe "when the actor has a display name" do
      it "returns a message with the actor's display name" do
        expect(notification.message).to(eq("#{actor.display_name} #{notification.content}"))
      end
    end

    describe "when the actor does not have a display name" do
      before { actor.update(display_name: nil) }

      it "returns a message with the actor's first part of the email" do
        expect(notification.message).to(eq("#{actor.email.split("@")[0]} #{notification.content}"))
      end
    end
  end
end
