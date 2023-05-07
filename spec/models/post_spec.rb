# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Post, type: :model) do
  context "associations" do
    it { should belong_to(:user) }
    it { should have_many(:comments) }
    it { should have_rich_text(:content) }
    it { should have_many(:likes) }
    it { should have_many(:likers).through(:likes) }
  end

  context "validations" do
    it { should validate_length_of(:content) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:user_id) }
  end
end
