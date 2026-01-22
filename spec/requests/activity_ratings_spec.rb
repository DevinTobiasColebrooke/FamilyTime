require 'rails_helper'

RSpec.describe "ActivityRatings", type: :request do
  let(:activity) { create(:activity) }
  let(:user) { create(:user) }
  let(:activity_rating) { create(:activity_rating, activity: activity, user: user) }

  before do
    login_as(user)
  end

  describe "POST /create" do
    it "redirects to the activity page" do
      post activity_activity_ratings_path(activity), params: { activity_rating: { score: 5, user_id: user.id } }
      expect(response).to redirect_to(event_path(activity))
    end
  end

  describe "PATCH /update" do
    it "redirects to the activity page" do
      patch activity_activity_rating_path(activity, activity_rating), params: { activity_rating: { score: 3 } }
      expect(response).to redirect_to(event_path(activity))
    end
  end

  describe "DELETE /destroy" do
    it "redirects to the activity page" do
      delete activity_activity_rating_path(activity, activity_rating)
      expect(response).to redirect_to(event_path(activity))
    end
  end
end
