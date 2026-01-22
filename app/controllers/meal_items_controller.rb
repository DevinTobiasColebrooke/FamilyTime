class MealItemsController < ApplicationController
  before_action :set_meal
  before_action :set_meal_item, only: [ :update, :destroy ]

  def create
    @meal_item = @meal.meal_items.build(meal_item_params)
    if @meal_item.save
      redirect_to event_path(@meal), notice: "Item added."
    else
      redirect_to event_path(@meal), alert: "Could not add item."
    end
  end

  def update
    if @meal_item.update(meal_item_params)
      redirect_to event_path(@meal), notice: "Item updated."
    else
      redirect_to event_path(@meal), alert: "Could not update item."
    end
  end

  def destroy
    @meal_item.destroy
    redirect_to event_path(@meal), notice: "Item removed."
  end

  private

  def set_meal
    @meal = Meal.find(params[:meal_id])
  end

  def set_meal_item
    @meal_item = @meal.meal_items.find(params[:id])
  end

  def meal_item_params
    params.require(:meal_item).permit(:name, :status, :note, :cost)
  end
end
