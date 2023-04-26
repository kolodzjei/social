# frozen_string_literal: true

require "rails_helper"

RSpec.describe(User, type: :model) do
  context "associations" do
    it { should have_many(:follower_relationships) }
    it { should have_many(:followers) }
    it { should have_many(:followed_relationships) }
    it { should have_many(:following) }
    it { should have_many(:posts) }
    it { should have_many(:likes) }
    it { should have_many(:comments) }
  end

  context "#follow" do
    it "should follow another user" do
    end
  end
end
