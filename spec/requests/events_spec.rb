require 'rails_helper'

RSpec.describe "Events", type: :request do
  let!(:event) { create(:event) }
  let(:user) { create(:user) }

  # Define valid attributes for standard reuse
  let(:valid_attributes) {
    {
      title: "Family Game Night",
      start_time: Time.current + 1.day,
      end_time: (Time.current + 1.day) + 2.hours,
      status: :planned,
      description: "Playing Catan"
    }
  }

  let(:invalid_attributes) {
    { title: "" } # Missing title
  }

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

  describe "POST /events" do
    context "with valid parameters" do
      it "creates a new Event" do
        expect {
          post events_path, params: { event: valid_attributes }
        }.to change(Event, :count).by(1)
      end

      it "redirects to the events list" do
        post events_path, params: { event: valid_attributes }
        expect(response).to redirect_to(events_path)
      end

      it "creates a Meal when type is specified" do
        meal_attributes = valid_attributes.merge(type: 'Meal')
        expect {
          post events_path, params: { event: meal_attributes }
        }.to change(Meal, :count).by(1)

        expect(Event.last.type).to eq('Meal')
      end

      it "creates an Activity when type is specified" do
        activity_attributes = valid_attributes.merge(type: 'Activity')
        expect {
          post events_path, params: { event: activity_attributes }
        }.to change(Activity, :count).by(1)

        expect(Event.last.type).to eq('Activity')
      end

      it "displays the created meal on the board" do
        meal_attributes = valid_attributes.merge(type: 'Meal', title: "Taco Tuesday")
        post events_path, params: { event: meal_attributes }
        follow_redirect!
        expect(response.body).to include("Taco Tuesday")
        # Ensure the type specific styling or text is present if possible,
        # but title is the main thing the user asked for.
      end

      it "displays the created activity on the board" do
        activity_attributes = valid_attributes.merge(type: 'Activity', title: "Soccer Practice")
        post events_path, params: { event: activity_attributes }
        follow_redirect!
        expect(response.body).to include("Soccer Practice")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Event" do
        expect {
          post events_path, params: { event: invalid_attributes }
        }.to change(Event, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post events_path, params: { event: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "recurring events" do
      it "creates multiple events" do
        post events_path, params: {
          event: {
            title: "Recurring Lunch",
            start_time: "2024-01-01 12:00:00",
            end_time: "2024-01-01 13:00:00",
            status: "planned",
            type: "Meal",
            recurrence_rule: "{\"interval\":1,\"until\":\"2024-01-03\",\"count\":null,\"validations\":{}}"
          }
        }

        expect(Event.count).to be >= 2
      end
    end
  end

  describe "PATCH /events/:id/update_status" do
    let!(:event1) { Event.create!(title: "Event 1", start_time: Time.current, end_time: 1.hour.from_now, status: :planned, position: 1) }
    let!(:event2) { Event.create!(title: "Event 2", start_time: Time.current, end_time: 1.hour.from_now, status: :planned, position: 2) }
    let!(:event3) { Event.create!(title: "Event 3", start_time: Time.current, end_time: 1.hour.from_now, status: :planned, position: 3) }

    it "updates the status and position" do
      # Initial order: event1 (1), event2 (2), event3 (3)
      # puts "Initial: E1:#{event1.position}, E2:#{event2.position}, E3:#{event3.position}"

      # Move event1 to position 1 (index 1 -> 2nd item)
      patch update_status_event_path(event1), params: { status: "planned", position: 1 }, as: :json

      expect(response).to have_http_status(:ok)

      event1.reload
      event2.reload
      event3.reload

      # puts "After: E1:#{event1.position}, E2:#{event2.position}, E3:#{event3.position}"

      # Expected order: event2 (1), event1 (2), event3 (3)
      expect(event2.position).to eq(1)
      expect(event1.position).to eq(2)
      expect(event3.position).to eq(3)
    end

    it "updates status and handles position in new list" do
      # Move event1 to 'doing' status at position 0
      patch update_status_event_path(event1), params: { status: "doing", position: 0 }, as: :json

      expect(response).to have_http_status(:ok)
      event1.reload

      expect(event1.status).to eq("doing")
      expect(event1.position).to eq(1)
    end
  end
end
