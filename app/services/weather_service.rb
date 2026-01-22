require "net/http"
require "json"

class WeatherService
  # Using Open-Meteo API (Free, no key required)
  # https://open-meteo.com/en/docs
  BASE_URL = "https://api.open-meteo.com/v1/forecast"

  # Default to New York for now if no location is provided
  # In a real app, we'd probably have location on the Event or User
  DEFAULT_LAT = 40.7128
  DEFAULT_LON = -74.0060

  def self.get_forecast(date, lat: DEFAULT_LAT, lon: DEFAULT_LON)
    return nil unless date.future? || date.today?

    # Open-Meteo only gives 7-14 days forecast comfortably for free without historical archive
    # So we only fetch if it's within the next 14 days
    return nil if date > 14.days.from_now.to_date

    begin
      # Fetch daily max/min temp and weathercode
      url = URI("#{BASE_URL}?latitude=#{lat}&longitude=#{lon}&daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=auto&start_date=#{date}&end_date=#{date}")

      response = Net::HTTP.get(url)
      data = JSON.parse(response)

      if data["daily"] && data["daily"]["time"].first == date.to_s
        {
          max_temp: data["daily"]["temperature_2m_max"].first,
          min_temp: data["daily"]["temperature_2m_min"].first,
          code: data["daily"]["weathercode"].first,
          description: weather_code_to_string(data["daily"]["weathercode"].first)
        }
      else
        nil
      end
    rescue StandardError => e
      Rails.logger.error("WeatherService Error: #{e.message}")
      nil
    end
  end

  private

  # WMO Weather interpretation codes (WW)
  def self.weather_code_to_string(code)
    case code
    when 0 then "Clear sky"
    when 1, 2, 3 then "Partly cloudy"
    when 45, 48 then "Foggy"
    when 51, 53, 55 then "Drizzle"
    when 56, 57 then "Freezing Drizzle"
    when 61, 63, 65 then "Rain"
    when 66, 67 then "Freezing Rain"
    when 71, 73, 75 then "Snow fall"
    when 77 then "Snow grains"
    when 80, 81, 82 then "Rain showers"
    when 85, 86 then "Snow showers"
    when 95 then "Thunderstorm"
    when 96, 99 then "Thunderstorm with hail"
    else "Unknown"
    end
  end
end
