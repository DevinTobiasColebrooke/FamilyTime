Rails.application.routes.draw do
  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  delete "sign_out", to: "sessions#destroy"

  root "events#index"
  get "calendar", to: "events#calendar"
  resource :grocery_list, only: [ :show ]
  namespace :users do
    resource :preference, only: [ :edit, :update ]
  end

  resources :events do
    member do
      patch :update_status
    end
  end

  resources :meals, controller: "events", type: "Meal" do
    resources :meal_items, only: [ :create, :update, :destroy ]
  end

  resources :activities, controller: "events", type: "Activity" do
    resources :activity_ratings, only: [ :create, :update, :destroy ]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
