# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Like, type: :model) do
  context "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:likeable) }
  end

  context "validations" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:likeable_id) }
    it { should validate_presence_of(:likeable_type) }
  end
end
