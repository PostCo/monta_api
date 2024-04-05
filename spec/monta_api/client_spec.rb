# frozen_string_literal: true

RSpec.describe MontaAPI::Client do
  subject do
    MontaAPI::Client.new(
      username: ENV["MONTA_USERNAME"],
      password: ENV["MONTA_PASSWORD"]
    )
  end

  it "uses correct base url" do
    expect(MontaAPI::Client::BASE_URL).to eq("https://api-v6.monta.nl/")
  end

  context "#return" do
    it { expect(subject.return).to be_a(MontaAPI::ReturnResource) }
  end

  context "#credit_note" do
    it { expect(subject.return_forecast).to be_a(MontaAPI::ReturnForecastResource) }
  end

  context "#connection" do
    it do
      connection = subject.connection
      expect(connection.builder.adapter).to eq(Faraday::Adapter::NetHttp)
      expect(connection.builder.handlers).to include(
        Faraday::Request::Json,
        Faraday::Response::Json,
        Faraday::Request::Authorization
      )
    end
  end
end
