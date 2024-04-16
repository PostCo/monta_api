# frozen_string_literal: true

RSpec.describe MontaAPI::ReturnForecastResource do
  subject { described_class.new(client) }

  let!(:client) do
    MontaAPI::Client.new(username: ENV["MONTA_USERNAME"], password: ENV["MONTA_PASSWORD"])
  end
  let(:basic_auth) { [ENV["MONTA_USERNAME"], ENV["MONTA_PASSWORD"]] }

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
        .with(basic_auth: basic_auth)
        .to_return_json(body: response_body, status: 200)
    end

    it do
      return_forecast = subject.find_by(code: "2")
      expect(return_forecast.code).to eq("2")
      expect(return_forecast.webshop_order_id).to eq("1173")
    end
  end

  describe "#create(attributes)" do
    let(:attributes) do
      {
        "Code": 2,
        "WebshopOrderId": "1173",
        "Lines": [
          {
            "WebshopOrderLineId": "14638817116463",
            "ReturnQuantity": 1,
            "ReturnReason": "Incorrect item received"
          }
        ]
      }
    end

    context "failed to create return forecast" do
      before do
        stub_request(:post, "#{MontaAPI::Client::BASE_URL}returnforecast")
          .with(body: attributes, basic_auth: basic_auth)
          .to_return_json(status: 400)
      end

      it do
        expect { subject.create(attributes) }.to raise_error(MontaAPI::Error)
      end
    end

    context "return forecast is created successfully" do
      let(:response_body) do
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
              "CustomerComment": nil
            }
          ],
          "CauseDescription": nil,
          "Comment": nil,
          "TrackAndTraceCode": nil,
          "TrackAndTraceLink": nil,
          "GeneralComment": nil
        }
      end

      before do
        stub_request(:post, "#{MontaAPI::Client::BASE_URL}returnforecast")
          .with(body: attributes, basic_auth: basic_auth)
          .to_return_json(status: 200, body: response_body)
      end

      it do
        return_forecast = subject.create(attributes)
        expect(return_forecast.code).to eq("2")
        expect(return_forecast.webshop_order_id).to eq("1173")
        expect(return_forecast.lines.count).to eq(1)
      end
    end
  end
end
