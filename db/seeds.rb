# Clear existing data
ActivityRating.destroy_all
MealItem.destroy_all
Event.destroy_all
User.destroy_all

# Create Users
mom = User.create!(name: "Mom", email: "mom@example.com", password: "password", password_confirmation: "password")
dad = User.create!(name: "Dad", email: "dad@example.com", password: "password", password_confirmation: "password")
kid = User.create!(name: "Kid", email: "kid@example.com", password: "password", password_confirmation: "password")

puts "Created #{User.count} users"

# Create Meals
taco_tuesday = Meal.create!(
  title: "Taco Tuesday",
  description: "Family favorite tacos with all the fixings",
  start_time: 1.day.from_now.change(hour: 18, min: 0),
  end_time: 1.day.from_now.change(hour: 19, min: 0),
  status: :planned
)

sunday_roast = Meal.create!(
  title: "Sunday Roast",
  description: "Traditional roast chicken with veggies",
  start_time: 5.days.from_now.change(hour: 13, min: 0),
  end_time: 5.days.from_now.change(hour: 15, min: 0),
  status: :planned
)

puts "Created #{Meal.count} meals"

# Create Meal Items
MealItem.create!(meal: taco_tuesday, name: "Ground Beef", status: :confirmed)
MealItem.create!(meal: taco_tuesday, name: "Tortillas", status: :confirmed)
MealItem.create!(meal: taco_tuesday, name: "Guacamole", status: :proposed)

MealItem.create!(meal: sunday_roast, name: "Whole Chicken", status: :confirmed)
MealItem.create!(meal: sunday_roast, name: "Potatoes", status: :confirmed)
MealItem.create!(meal: sunday_roast, name: "Carrots", status: :confirmed)

puts "Created #{MealItem.count} meal items"

# Create Activities
movie_night = Activity.create!(
  title: "Movie Night",
  description: "Watching the new superhero movie",
  start_time: 2.days.from_now.change(hour: 19, min: 0),
  end_time: 2.days.from_now.change(hour: 21, min: 30),
  status: :planned
)

hiking = Activity.create!(
  title: "Hiking Trip",
  description: "Hiking the nearby trail",
  start_time: 4.days.from_now.change(hour: 9, min: 0),
  end_time: 4.days.from_now.change(hour: 12, min: 0),
  status: :planned
)

puts "Created #{Activity.count} activities"

# Create Activity Ratings
ActivityRating.create!(activity: movie_night, user: mom, score: 4, note: "Popcorn is a must!")
ActivityRating.create!(activity: movie_night, user: kid, score: 5, note: "Can't wait!")
ActivityRating.create!(activity: hiking, user: dad, score: 5, note: "Fresh air!")
ActivityRating.create!(activity: hiking, user: kid, score: 2, note: "Too much walking...")

puts "Created #{ActivityRating.count} activity ratings"
