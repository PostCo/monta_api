# frozen_string_literal: true

RSpec.describe MontaAPI::Object do
  subject { described_class }

  context "initialize" do
    let(:attributes) { {"Code" => "2", "WebshopOrderId" => "1173" } }

    it "is an OpenStruct" do
      expect(subject.new(attributes)).to be_a(OpenStruct)
    end

    it "convert the attributes keys to snake case" do
      monta_api_object = subject.new(attributes)

      expect(monta_api_object.each_pair.to_a).to match(
        [[:code, "2"], [:webshop_order_id, "1173"]]
      )
    end
  end
end
