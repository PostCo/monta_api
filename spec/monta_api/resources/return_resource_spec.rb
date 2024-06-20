# frozen_string_literal: true

RSpec.describe MontaAPI::ReturnResource, type: :request do
  subject { described_class.new(client) }

  let!(:client) do
    MontaAPI::Client.new(username: ENV["MONTA_USERNAME"], password: ENV["MONTA_PASSWORD"])
  end

  describe "#where(since:, status: 'any')" do
    let!(:updated_since) { "2024-04-05" }
    let!(:response_body) do
      {
        "Returns": [
          {
            "Id": 3_873_210,
            "CreatedAt": "2024-04-05T08:40:40.327",
            "Comment": nil,
            "Cause": "Ik ben van gedachten veranderd",
            "WebshopCause": nil,
            "WebshopOrderId": "1173",
            "Lines": [
              {
                "WebshopOrderLineId": "14638817116463",
                "Sku": "ABC",
                "ReturnedQuantity": 1,
                "Sellable": true,
                "FollowedUpMontapacking": false,
                "FollowedUpCustomer": false,
                "FollowedUpAction": nil,
                "Cause": "Ik ben van gedachten veranderd",
                "Comment": nil,
                "BatchCode": nil
              }
            ],
            "UpdatedAt": "2024-04-05T08:41:33.81",
            "SerialNumbers": [],
            "ReturnForecastId": 2_361_500,
            "ForecastCode": "2"
          }
        ]
      }
    end

    before do
      stub_request(:get, "#{MontaAPI::Client::BASE_URL}return/updated_since/#{updated_since}")
        .with(query: { status: "any" }, basic_auth: [ENV["MONTA_USERNAME"], ENV["MONTA_PASSWORD"]])
        .to_return_json(body: response_body, status: 200)
    end

    it do
      returns = subject.where(since: updated_since)
      expect(returns.count).to eq(1)
      expect(returns.map(&:id)).to eq([3_873_210])
      expect(returns.map(&:forecast_code)).to eq(["2"])
      expect(returns.map(&:webshop_order_id)).to eq(["1173"])
    end
  end

  describe "#follow_up_multiple_lines(return_id:, attributes: 'any')" do
    let!(:return_id) { 1 }

    context "when follow up successfully" do
      let!(:attributes) do
        [{ "LineId" => 123, "Status" => "Refunded" }, { "LineId" => 234, "Status" => "NewOrderCreated" }]
      end

      before do
        stub_request(:put, "#{MontaAPI::Client::BASE_URL}return/#{return_id}/update_return_status/multiple_lines")
          .with(body: attributes, basic_auth: [ENV["MONTA_USERNAME"], ENV["MONTA_PASSWORD"]])
          .to_return(body: "Successfully changed the statuses of multiple ReturnLines", status: 200)
      end

      it do
        result = subject.follow_up_multiple_lines(return_id: return_id, attributes: attributes)

        expect(result).to eq("Successfully changed the statuses of multiple ReturnLines")
      end
    end

    context "when failed to follow up" do
      let!(:attributes) do
        [{ "LineId" => 123, "Status" => "Invalid status" }, { "LineId" => 234, "Status" => "Invalid status" }]
      end
      let!(:response_body) do
        {
          "ErrorMessage": "An error occurred when updating the status of a/multiple line(s). The statuses were not updated.",
          "InvalidReasons": [
            "The newly chosen return status 'wrong' is invalid. Make sure to use a valid status.",
            "The newly chosen return status 'wrong' is invalid. Make sure to use a valid status."
          ]
        }
      end

      before do
        stub_request(:put, "#{MontaAPI::Client::BASE_URL}return/#{return_id}/update_return_status/multiple_lines")
          .with(body: attributes, basic_auth: [ENV["MONTA_USERNAME"], ENV["MONTA_PASSWORD"]])
          .to_return_json(body: response_body, status: 400)
      end

      it do
        expect do
          subject.follow_up_multiple_lines(return_id: return_id, attributes: attributes)
        end.to raise_error(MontaAPI::Error)
      end
    end
  end

  describe "#follow_up(return_id:, status:)" do
    let(:return_id) { 1 }
    let(:status) { "Refunded" }

    context "when follow up successfully" do
      let(:response_body) { "Successfully changed status of return '#{return_id}' from 'none' to '#{status}'." }

      before do
        stub_request(:put, "#{MontaAPI::Client::BASE_URL}return/#{return_id}/update_return_status/#{status}")
          .with(basic_auth: [ENV["MONTA_USERNAME"], ENV["MONTA_PASSWORD"]])
          .to_return(body: response_body, status: 200)
      end

      it do
        result = subject.follow_up(return_id: return_id, status: status)
        expect(result).to eq(response_body)
      end
    end

    context "when failed to follow up" do
      let(:response_body) { "Fail to follow up return" }

      before do
        stub_request(:put, "#{MontaAPI::Client::BASE_URL}return/#{return_id}/update_return_status/#{status}")
          .with(basic_auth: [ENV["MONTA_USERNAME"], ENV["MONTA_PASSWORD"]])
          .to_return(body: response_body, status: 400)
      end

      it do
        expect { subject.follow_up(return_id: return_id, status: status) }.to raise_error(MontaAPI::Error)
      end
    end
  end
end
