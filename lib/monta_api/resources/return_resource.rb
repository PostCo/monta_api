# frozen_string_literal: true

module MontaAPI
  class ReturnResource < Resource
    # @client.return.where(since: "2024-04-05", status: "any")
    def where(since:, status: "any")
      response_body = get_request("return/updated_since/#{since}", params: { status: status }).body

      response_body["Returns"].map { |attributes| Return.new(attributes) }
    end
  end
end
