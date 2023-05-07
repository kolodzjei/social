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
    it { should have_many(:replies) }
    it { should have_one_attached(:avatar) }
  end

  context "validations" do
    it { should validate_length_of(:display_name).is_at_least(3).is_at_most(15) }
    it { should validate_content_type_of(:avatar).allowing("png", "jpg", "jpeg") }
    it { should validate_size_of(:avatar).less_than(5.megabytes) }
  end

  context "#follow" do
    it "should follow another user" do
      u = create(:user)
      u2 = create(:user)
      expect { u.follow(u2) }.to(change { u.following.count }.by(1))
    end

    it "should not follow another user twice" do
      u = create(:user)
      u2 = create(:user)
      u.follow(u2)
      expect { u.follow(u2) }.to_not(change { u.following.count })
    end

    it "should not follow itself" do
      u = create(:user)
      expect { u.follow(u) }.to_not(change { u.following.count })
    end
  end

  context "#unfollow" do
    it "should unfollow another user" do
      u = create(:user)
      u2 = create(:user)
      u2.followers << u
      expect { u.unfollow(u2) }.to(change { u.following.count }.by(-1))
    end

    it "should not unfollow another user if is not followed" do
      u = create(:user)
      u2 = create(:user)
      expect { u.unfollow(u2) }.to_not(change { u.following.count })
    end
  end

  context "#following?" do
    it "should return true if user is following another user" do
      u = create(:user)
      u2 = create(:user)
      u2.followers << u
      expect(u.following?(u2)).to(be(true))
    end

    it "should return false if user is not following another user" do
      u = create(:user)
      u2 = create(:user)
      expect(u.following?(u2)).to(be(false))
    end
  end

  context "#from_omniauth" do
    it "should create a new user if it does not exist" do
      auth = OmniAuth::AuthHash.new(Faker::Omniauth.google)
      expect { User.from_omniauth(auth) }.to(change { User.count }.by(1))
    end

    it "should return the user if it exists" do
      auth = OmniAuth::AuthHash.new(Faker::Omniauth.google)
      User.from_omniauth(auth)
      expect { User.from_omniauth(auth) }.to_not(change { User.count })
      expect(User.from_omniauth(auth)).to(eq(User.last))
    end
  end
end
