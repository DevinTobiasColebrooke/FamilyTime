class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy update_status ]

  def index
    @events = Event.search(params[:query])
                   .by_type(params[:type])
                   .by_status(params[:status])
                   .by_time_range(params[:time_range])

    @planned_events = @events.where(status: :planned).order(position: :asc)
    @doing_events = @events.where(status: :doing).order(position: :asc)
    @done_events = @events.where(status: :done).order(position: :asc)

    @planned_cost = @planned_events.sum(:cost)
    @doing_cost = @doing_events.sum(:cost)
    @done_cost = @done_events.sum(:cost)

    # Simple alert logic: Events starting within the next 2 hours or currently happening
    @imminent_events = Event.where(status: [ :planned, :doing ])
                            .where("start_time <= ? AND end_time >= ?", 2.hours.from_now, Time.current)
  end

  def calendar
    # simple_calendar expects a collection of events
    # It uses params[:start_date] to determine the month
    start_date = params.fetch(:start_date, Date.today).to_date
    @events = Event.where(start_time: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
  end

  def show
    if @event.type == "Activity" && @event.start_time.future?
      @weather_forecast = WeatherService.get_forecast(@event.start_time.to_date)
    end
  end

  def new
    type = params[:type] || "Event"
    @event = type.constantize.new
  end

  def edit
  end

  def create
    type = params.dig(:event, :type) || "Event"
    @event = type.constantize.new(event_params)

    if @event.save
      RecurrenceService.new(@event).generate_instances
      redirect_to events_path, notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      redirect_to events_path, notice: "Event was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "Event was successfully destroyed."
  end

  def update_status
    @event.update(status: params[:status])
    if params[:position].present?
      @event.insert_at(params[:position].to_i + 1)
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to events_path, notice: "Event status updated." }
      format.json { render json: @event, status: :ok }
    end
  end

  private
    def set_event
      @event = Event.find(params[:id])
      # Eager load activity ratings if it's an Activity
      if @event.type == "Activity"
        ActiveRecord::Associations::Preloader.new(records: [ @event ], associations: { activity_ratings: :user }).call
      end
    end

    def event_params
      params.require(:event).permit(:title, :description, :start_time, :end_time, :status, :type, :recurrence_rule, :cost)
    end
end
