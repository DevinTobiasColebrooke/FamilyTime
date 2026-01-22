require 'rails_helper'

RSpec.describe "MealItems", type: :request do
  let(:meal) { create(:meal) }
  let(:meal_item) { create(:meal_item, meal: meal) }
  let(:user) { create(:user) }

  before { login_as(user) }

  describe "POST /create" do
    it "redirects to the meal page" do
      post meal_meal_items_path(meal), params: { meal_item: { name: "Pizza", status: :proposed } }
      expect(response).to redirect_to(event_path(meal))
    end

    it "creates a meal item with cost" do
      expect {
        post meal_meal_items_path(meal), params: { meal_item: { name: "Pizza", status: :proposed, cost: 12.50 } }
      }.to change(MealItem, :count).by(1)

      expect(MealItem.last.cost).to eq(12.50)
    end
  end

  describe "PATCH /update" do
    it "redirects to the meal page" do
      patch meal_meal_item_path(meal, meal_item), params: { meal_item: { status: :confirmed } }
      expect(response).to redirect_to(event_path(meal))
    end
  end

  describe "DELETE /destroy" do
    it "redirects to the meal page" do
      delete meal_meal_item_path(meal, meal_item)
      expect(response).to redirect_to(event_path(meal))
    end
  end
end
