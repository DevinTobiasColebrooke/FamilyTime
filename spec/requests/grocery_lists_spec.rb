require 'rails_helper'

RSpec.describe "GroceryLists", type: :request do
  let(:user) { create(:user) }

  before { login_as(user) }

  describe "GET /show" do
    it "returns http success" do
      get grocery_list_path
      expect(response).to have_http_status(:success)
    end
  end
end
