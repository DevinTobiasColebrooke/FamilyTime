require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "acts_as_list" do
    let!(:planned_event_1) { create(:event, status: :planned) }
    let!(:planned_event_2) { create(:event, status: :planned) }
    let!(:doing_event_1) { create(:event, status: :doing) }

    it "automatically assigns position to new events in the same scope" do
      expect(planned_event_1.position).to eq(1)
      expect(planned_event_2.position).to eq(2)
      expect(doing_event_1.position).to eq(1) # Different scope (status)
    end

    it "reorders events when position changes" do
      planned_event_2.move_to_top
      expect(planned_event_2.position).to eq(1)
      planned_event_1.reload
      expect(planned_event_1.position).to eq(2)
    end

    it "manages position when scope (status) changes" do
      # Move planned_event_1 to doing
      planned_event_1.update(status: :doing)

      # It should be added to the bottom of the "doing" list
      expect(planned_event_1.position).to eq(2)

      # And planned_event_2 should move up in the "planned" list
      planned_event_2.reload
      expect(planned_event_2.position).to eq(1)
    end
  end
end
