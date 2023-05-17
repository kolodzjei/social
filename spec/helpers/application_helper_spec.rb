# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ApplicationHelper, type: :helper) do
  context "#display_name" do
    let(:user) { create(:user) }

    describe "when the user has a display name" do
      it "returns the user's display name" do
        expect(display_name(user)).to(eq(user.display_name))
      end
    end

    describe "when the user does not have a display name" do
      before { user.update(display_name: nil) }

      it "returns the user's first part of the email" do
        expect(display_name(user)).to(eq(user.email.split("@")[0]))
      end
    end
  end
end
