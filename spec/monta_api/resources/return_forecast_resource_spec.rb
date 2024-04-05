# frozen_string_literal: true

RSpec.describe MontaAPI::ReturnForecastResource do
  subject { described_class.new(client) }

  let!(:client) do
    MontaAPI::Client.new(username: ENV["MONTA_USERNAME"], password: ENV["MONTA_PASSWORD"])
  end

  describe "#find_by(code:)" do
    it do
      VCR.use_cassette("return_forecast_find_by") do
        return_forecast = subject.find_by(code: "2")
        expect(return_forecast.code).to eq("2")
        expect(return_forecast.webshop_order_id).to eq("1173")
      end
    end
  end
end
