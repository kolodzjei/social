# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Notifications::CommentNotifierJob, type: :job) do
  describe "#perform" do
    let(:actor) { create(:user) }
    let(:post) { create(:post, user: actor) }
    let(:comment) { create(:comment, user: actor, post: post) }
    let(:args) { { "actor_id" => actor.id, "comment_id" => comment.id } }

    it "calls CommentNotifier#notify" do
      expect_any_instance_of(Notifications::CommentNotifier).to(receive(:notify))
      described_class.new.perform(args)
    end

    context "when actor or comment is not found" do
      it "does not call CommentNotifier#notify" do
        expect_any_instance_of(Notifications::CommentNotifier).not_to(receive(:notify))
        described_class.new.perform({ "actor_id" => 0, "comment_id" => comment.id })
        described_class.new.perform({ "actor_id" => actor.id, "comment_id" => 0 })
      end
    end
  end
end
