# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Notifications::ReplyNotifierJob, type: :job) do
  describe "#perform" do
    let(:user) { create(:user) }
    let(:post) { create(:post, user: user) }
    let(:comment) { create(:comment, post: post, user: user) }
    let(:reply) { create(:reply, comment: comment, user: user) }

    context "when both reply and user exist" do
      it "calls ReplyNotifier#notify" do
        expect_any_instance_of(Notifications::ReplyNotifier).to(receive(:notify))
        described_class.new.perform({ "reply_id" => reply.id, "actor_id" => user.id })
      end
    end

    context "when either reply or user does not exist" do
      it "does not call ReplyNotifier#notify" do
        expect_any_instance_of(Notifications::ReplyNotifier).not_to(receive(:notify))
        described_class.new.perform({ "reply_id" => 0, "actor_id" => user.id })
        described_class.new.perform({ "reply_id" => reply.id, "actor_id" => 0 })
      end
    end
  end
end
