# frozen_string_literal: true

RSpec.describe MontaAPI::ReturnForecastResource do
  subject { described_class.new(client) }

  let!(:client) do
    MontaAPI::Client.new(username: ENV["MONTA_USERNAME"], password: ENV["MONTA_PASSWORD"])
  end

  describe "#find_by(code:)" do
    let!(:code) { "2" }
    let!(:response_body) do
      {
        "Code": "2",
        "WebshopOrderId": "1173",
        "Lines": [
          {
            "WebshopOrderLineId": "14638817116463",
            "ReturnQuantity": 1,
            "ReturnReason": "Incorrect item received",
            "RelatieRetourOorzaakId": nil,
            "RelatieRetourOorzaakParentId": nil,
            "CustomerComment": ""
          }
        ],
        "CauseDescription": "",
        "Comment": "",
        "TrackAndTraceCode": nil,
        "TrackAndTraceLink": nil,
        "GeneralComment": ""
      }
    end

    before do
      stub_request(:get, "#{MontaAPI::Client::BASE_URL}returnforecast/#{code}")
        .with(basic_auth: [ENV["MONTA_USERNAME"], ENV["MONTA_PASSWORD"]])
        .to_return_json(body: response_body, status: 200)
    end

    it do
      return_forecast = subject.find_by(code: "2")
      expect(return_forecast.code).to eq("2")
      expect(return_forecast.webshop_order_id).to eq("1173")
    end
  end
end
