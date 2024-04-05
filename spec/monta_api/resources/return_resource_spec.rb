# frozen_string_literal: true

RSpec.describe MontaAPI::ReturnResource do
  subject { described_class.new(client) }

  let!(:client) do
    MontaAPI::Client.new(username: ENV["MONTA_USERNAME"], password: ENV["MONTA_PASSWORD"])
  end

  describe "#where(since:, status: 'any')" do
    it do
      VCR.use_cassette("return_where") do
        returns = subject.where(since: "2024-04-05")
        expect(returns.count).to eq(1)
        expect(returns.map(&:id)).to eq([3_873_210])
        expect(returns.map(&:forecast_code)).to eq(["2"])
        expect(returns.map(&:webshop_order_id)).to eq(["1173"])
      end
    end
  end
end
