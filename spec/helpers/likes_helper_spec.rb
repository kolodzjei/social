# frozen_string_literal: true

require "rails_helper"

RSpec.describe(LikesHelper, type: :helper) do
  describe "#path_for_likeable" do
    let(:user) { create(:user) }
    let(:post) { create(:post, user: user) }
    let(:comment) { create(:comment, user: user, post: post) }
    let(:reply) { create(:reply, user: user, comment: comment) }

    context "when the likeable is a post" do
      it "returns the path for the post" do
        expect(path_for_likeable(post)).to(eq("post_likes_path"))
      end
    end

    context "when the likeable is a comment" do
      it "returns the path for the comment" do
        expect(path_for_likeable(comment)).to(eq("comment_likes_path"))
      end
    end

    context "when the likeable is a reply" do
      it "returns the path for the reply" do
        expect(path_for_likeable(reply)).to(eq("reply_likes_path"))
      end
    end
  end
end
