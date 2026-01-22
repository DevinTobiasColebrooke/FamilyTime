require 'rails_helper'

RSpec.describe "Events", type: :request do
  let!(:event) { create(:event) }
  let(:user) { create(:user) }

  before { login_as(user) }

  describe "GET /index" do
    it "returns http success" do
      get events_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get event_path(event)
      expect(response).to have_http_status(:success)
    end

    context "with costs" do
      let(:meal) { create(:meal, cost: 20.00) }
      let!(:meal_item) { create(:meal_item, meal: meal, cost: 15.50) }

      it "displays the total cost" do
        get event_path(meal)
        expect(response.body).to include("35.50")
      end
    end

    context "with weather" do
      let(:activity) { create(:activity, start_time: 1.day.from_now) }

      before do
        allow(WeatherService).to receive(:get_forecast).and_return({
          max_temp: 22.0,
          min_temp: 18.0,
          code: 0,
          description: "Clear sky"
        })
      end

      it "displays the weather forecast" do
        get event_path(activity)
        expect(response.body).to include("Clear sky")
        expect(response.body).to include("22.0°")
      end
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get new_event_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get edit_event_path(event)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /calendar" do
    it "returns http success" do
      get calendar_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /events (recurring)" do
    it "creates multiple events" do
      expect {
        post events_path, params: { event: {
          title: "Weekly Meeting",
          start_time: Time.current,
          end_time: Time.current + 1.hour,
          status: :planned,
          recurrence_rule: "weekly"
        } }
      }.to change(Event, :count).by(5) # 1 parent + 4 instances
    end
  end
end
