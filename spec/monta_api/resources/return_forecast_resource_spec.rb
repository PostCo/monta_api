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

  describe "#generate_label(forecast_code:, shipper_code:)" do
    context "when label genarated successfully" do
      let!(:forecast_code) { "MP1" }
      let!(:shipper_code) { "DPD" }
      let!(:encoded_data) { "abcdefgh" }
      let!(:track_and_trace_link) { "https://track-and-trace.com" }
      let!(:response_body) do
        {
          "EncodedData": encoded_data,
          "FileExtension": "pdf",
          "TrackAndTraceLink": track_and_trace_link
        }
      end

      before do
        stub_request(:get, "#{MontaAPI::Client::BASE_URL}returnforecast/#{forecast_code}/returnlabel")
          .with(query: { shipperCode: shipper_code }, basic_auth: basic_auth)
          .to_return_json(status: 200, body: response_body)
      end

      it do
        return_label = subject.generate_label(forecast_code: forecast_code, shipper_code: shipper_code)
        expect(return_label.encoded_data).to eq(encoded_data)
        expect(return_label.file_extension).to eq("pdf")
        expect(return_label.track_and_trace_link).to eq(track_and_trace_link)
      end
    end

    context "when failed to generate label" do
      let!(:forecast_code) { "MP1" }
      let!(:shipper_code) { "DPD" }
      let!(:encoded_data) { "abcdefgh" }
      let!(:track_and_trace_link) { "https://track-and-trace.com" }
      let!(:response_body) do
        {
          "EncodedData": encoded_data,
          "FileExtension": "pdf",
          "TrackAndTraceLink": track_and_trace_link
        }
      end

      before do
        stub_request(:get, "#{MontaAPI::Client::BASE_URL}returnforecast/#{forecast_code}/returnlabel")
          .with(query: { shipperCode: shipper_code }, basic_auth: basic_auth)
          .to_return(status: 400, body: "shipper not allowed")
      end

      it do
        expect do
          subject.generate_label(forecast_code: forecast_code, shipper_code: shipper_code)
        end.to raise_error(MontaAPI::Error)
      end
    end
  end
end
