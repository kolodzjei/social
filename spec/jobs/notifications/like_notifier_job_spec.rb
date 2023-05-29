# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Notifications::LikeNotifierJob, type: :job) do
  describe "#perform" do
    let(:user) { create(:user) }
    let(:post) { create(:post, user: user) }
    let(:comment) { create(:comment, user: user, post: post) }
    let(:reply) { create(:reply, user: user, comment: comment) }

    context "when the likeable is a post" do
      context "when the post and user exists" do
        let(:args) { { "likeable_type" => "Post", "likeable_id" => post.id, "user_id" => user.id } }

        it "calls LikeNotifier#notify" do
          expect_any_instance_of(Notifications::LikeNotifier).to(receive(:notify))
          described_class.new.perform(args)
        end
      end

      context "when either the post or user does not exist" do
        it "does not call LikeNotifier#notify" do
          expect_any_instance_of(Notifications::LikeNotifier).not_to(receive(:notify))
          described_class.new.perform({ "likeable_type" => "Post", "likeable_id" => 0, "user_id" => user.id })
          described_class.new.perform({ "likeable_type" => "Post", "likeable_id" => post.id, "user_id" => 0 })
        end
      end
    end

    context "when the likeable is a comment" do
      context "when the comment and user exists" do
        let(:args) { { "likeable_type" => "Comment", "likeable_id" => comment.id, "user_id" => user.id } }

        it "calls LikeNotifier#notify" do
          expect_any_instance_of(Notifications::LikeNotifier).to(receive(:notify))
          described_class.new.perform(args)
        end
      end

      context "when either the comment or user does not exist" do
        it "does not call LikeNotifier#notify" do
          expect_any_instance_of(Notifications::LikeNotifier).not_to(receive(:notify))
          described_class.new.perform({ "likeable_type" => "Comment", "likeable_id" => 0, "user_id" => user.id })
          described_class.new.perform({ "likeable_type" => "Comment", "likeable_id" => comment.id, "user_id" => 0 })
        end
      end
    end

    context "when the likeable is a reply" do
      context "when the reply and user exists" do
        let(:args) { { "likeable_type" => "Reply", "likeable_id" => reply.id, "user_id" => user.id } }

        it "calls LikeNotifier#notify" do
          expect_any_instance_of(Notifications::LikeNotifier).to(receive(:notify))
          described_class.new.perform(args)
        end
      end

      context "when either the reply or user does not exist" do
        it "does not call LikeNotifier#notify" do
          expect_any_instance_of(Notifications::LikeNotifier).not_to(receive(:notify))
          described_class.new.perform({ "likeable_type" => "Reply", "likeable_id" => 0, "user_id" => user.id })
          described_class.new.perform({ "likeable_type" => "Reply", "likeable_id" => reply.id, "user_id" => 0 })
        end
      end
    end
  end
end
