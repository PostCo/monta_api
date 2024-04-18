module MontaAPI
  class ReturnReasonResource < Resource
    # @client.return_reason.all
    # Response:
    # {
    #   [
    #     {
    #         "Id": 2447,
    #         "Description": "Zelf verzonnen reden 1",
    #         "Translations": {}
    #     },
    #     {
    #         "Id": 2448,
    #         "Description": "Zelf verzonnen reden 2",
    #         "Translations": {
    #         "en": "Madeup reason 2",
    #         "de": "Erfundener Grund 2"
    #          }
    #     }
    #   ]
    # }

    def all
      response_body = get_request("returnreasons").body
      response_body.map { |attributes| ReturnReason.new(attributes) }
    end
  end
end
