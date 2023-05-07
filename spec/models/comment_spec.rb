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
end
