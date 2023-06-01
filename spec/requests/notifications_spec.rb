require "rails_helper"

RSpec.describe "Notifications", type: :request do
  describe "GET /notifications" do
    context "when user is not logged in" do
      it "redirects to login page" do
        get notifications_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      before do
        sign_in create(:user)
      end

      it "returns http success" do
        get notifications_path
        expect(response).to have_http_status(:success)
      end
    end
  end
end