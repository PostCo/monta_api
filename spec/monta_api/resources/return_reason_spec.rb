# frozen_string_literal: true

RSpec.describe MontaAPI::ReturnReasonResource, type: :request do
  subject { described_class.new(client) }

  let!(:client) do
    MontaAPI::Client.new(username: ENV["MONTA_USERNAME"], password: ENV["MONTA_PASSWORD"])
  end

  describe "#all" do
    let(:response_body) do
      [
        {
          "Id": 2447,
          "Description": "Zelf verzonnen reden 1",
          "Translations": {}
        },
        {
          "Id": 2448,
          "Description": "Zelf verzonnen reden 2",
          "Translations": {
            "en": "Madeup reason 2",
            "de": "Erfundener Grund 2"
          }
        }
      ]
    end

    before do
      stub_request(:get, "#{MontaAPI::Client::BASE_URL}returnreasons")
        .with(basic_auth: [ENV["MONTA_USERNAME"], ENV["MONTA_PASSWORD"]])
        .to_return_json(body: response_body, status: 200)
    end

    it do
      return_reasons = subject.all

      expect(return_reasons.count).to eq(2)
      expect(return_reasons.map(&:id)).to eq([2447, 2448])
    end
  end
end
