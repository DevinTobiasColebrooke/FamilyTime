class GroceryListsController < ApplicationController
  def show
    # Fetch items for upcoming meals that are not 'removed'
    @items = MealItem.joins(:meal)
                     .includes(:meal)
                     .merge(Event.upcoming)
                     .where.not(status: :removed)
                     .order("events.start_time ASC")
                     .group_by(&:meal)
  end
end
