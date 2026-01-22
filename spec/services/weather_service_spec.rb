require 'rails_helper'
require 'webmock/rspec'

RSpec.describe WeatherService do
  describe '.get_forecast' do
    let(:date) { 1.day.from_now.to_date }

    context 'when API call is successful' do
      before do
        stub_request(:get, /api.open-meteo.com/).to_return(
          status: 200,
          body: {
            "daily" => {
              "time" => [ date.to_s ],
              "temperature_2m_max" => [ 25.5 ],
              "temperature_2m_min" => [ 15.0 ],
              "weathercode" => [ 1 ]
            }
          }.to_json
        )
      end

      it 'returns formatted weather data' do
        result = described_class.get_forecast(date)

        expect(result).to be_a(Hash)
        expect(result[:max_temp]).to eq(25.5)
        expect(result[:min_temp]).to eq(15.0)
        expect(result[:code]).to eq(1)
        expect(result[:description]).to eq("Partly cloudy")
      end
    end

    context 'when date is in the past' do
      it 'returns nil' do
        expect(described_class.get_forecast(1.day.ago.to_date)).to be_nil
      end
    end

    context 'when date is too far in future' do
      it 'returns nil' do
        expect(described_class.get_forecast(20.days.from_now.to_date)).to be_nil
      end
    end

    context 'when API fails' do
      before do
        stub_request(:get, /api.open-meteo.com/).to_return(status: 500)
      end

      it 'returns nil gracefully' do
        expect(described_class.get_forecast(date)).to be_nil
      end
    end
  end
end
