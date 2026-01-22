class ActivityRatingsController < ApplicationController
  before_action :set_activity
  before_action :set_rating, only: [ :update, :destroy ]

  def create
    @rating = @activity.activity_ratings.build(rating_params)
    @rating.user = Current.user

    if @rating.save
      redirect_to event_path(@activity), notice: "Rating added."
    else
      redirect_to event_path(@activity), alert: "Could not add rating."
    end
  end

  def update
    if @rating.update(rating_params)
      redirect_to event_path(@activity), notice: "Rating updated."
    else
      redirect_to event_path(@activity), alert: "Could not update rating."
    end
  end

  def destroy
    @rating.destroy
    redirect_to event_path(@activity), notice: "Rating removed."
  end

  private

  def set_activity
    @activity = Activity.find(params[:activity_id])
  end

  def set_rating
    @rating = @activity.activity_ratings.find(params[:id])
  end

  def rating_params
    params.require(:activity_rating).permit(:score, :note)
  end
end
