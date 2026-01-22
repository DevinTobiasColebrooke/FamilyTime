require 'rails_helper'

RSpec.describe "Users::Preferences", type: :request do
  let(:user) { User.create!(name: "Test User", email: "test@example.com", password: "password") }

  before do
    post sign_in_path, params: { email: user.email, password: user.password }
  end

  describe "GET /users/preference/edit" do
    it "returns http success" do
      get edit_users_preference_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /users/preference" do
    context "with valid parameters" do
      it "updates the user" do
        patch users_preference_path, params: { user: { name: "New Name" } }
        expect(user.reload.name).to eq("New Name")
      end

      it "redirects to the edit page" do
        patch users_preference_path, params: { user: { name: "New Name" } }
        expect(response).to redirect_to(edit_users_preference_path)
      end
    end

    context "with invalid parameters" do
      it "does not update the user" do
        patch users_preference_path, params: { user: { email: "" } }
        expect(user.reload.email).to eq("test@example.com")
      end

      it "renders the edit page" do
        patch users_preference_path, params: { user: { email: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
