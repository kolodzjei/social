# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Notifications::FollowNotifierJob, type: :job) do
  describe "#perform" do
    context "when both users exist" do
      let(:following) { create(:user) }
      let(:followed) { create(:user) }
      let(:args) { { "following_id" => following.id, "followed_id" => followed.id } }

      it "calls FollowNotifier#notify" do
        expect_any_instance_of(Notifications::FollowNotifier).to(receive(:notify))
        described_class.new.perform(args)
      end
    end

    context "when either user does not exist" do
      let(:args) { { "following_id" => 0, "followed_id" => 0 } }

      it "does not call FollowNotifier#notify" do
        expect_any_instance_of(Notifications::FollowNotifier).not_to(receive(:notify))
        described_class.new.perform(args)
      end
    end
  end
end
