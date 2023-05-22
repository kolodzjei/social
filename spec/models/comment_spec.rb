# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Comment, type: :model) do
  context "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
    it { should have_many(:replies).dependent(:destroy) }
    it { should have_rich_text(:content) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:likers).through(:likes) }
  end

  context "validations" do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:post_id) }
  end

  describe "#replies_count" do
    let(:user) { create(:user) }
    let(:post) { create(:post, user: user) }
    let(:comment) { create(:comment, user: user, post: post) }
    let!(:reply) { create(:reply, user: user, comment: comment) }

    before do
      create(:reply, user: user, comment: comment, parent_reply: reply)
    end

    it "returns the number of replies without nested replies" do
      expect(comment.replies_count).to(eq(1))
    end
  end
end
