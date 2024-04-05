# frozen_string_literal: true

module MontaAPI
  class ReturnForecastResource < Resource
    # @client.return_forecast.find_by(code: "2")
    # Response
    # {
    #   "Code": "2",
    #   "WebshopOrderId": "1173",
    #   "Lines": [
    #     {
    #       "WebshopOrderLineId": "14638817116463",
    #       "ReturnQuantity": 1,
    #       "ReturnReason": "Incorrect item received",
    #       "RelatieRetourOorzaakId": null,
    #       "RelatieRetourOorzaakParentId": null,
    #       "CustomerComment": ""
    #     }
    #   ],
    #   "CauseDescription": "",
    #   "Comment": "",
    #   "TrackAndTraceCode": null,
    #   "TrackAndTraceLink": null,
    #   "GeneralComment": ""
    # }
    def find_by(code:)
      response_body = get_request("returnforecast/#{code}").body

      ReturnForecast.new(response_body)
    end

    # @client.return_forecast.create(...)
    # Response:
    # {
    #   "Code": "2",
    #   "WebshopOrderId": "1173",
    #   "Lines": [
    #     {
    #       "WebshopOrderLineId": "14638817116463",
    #       "ReturnQuantity": 1,
    #       "ReturnReason": "Incorrect item received",
    #       "RelatieRetourOorzaakId": null,
    #       "RelatieRetourOorzaakParentId": null,
    #       "CustomerComment": null
    #     }
    #   ],
    #   "CauseDescription": null,
    #   "Comment": null,
    #   "TrackAndTraceCode": null,
    #   "TrackAndTraceLink": null,
    #   "GeneralComment": null
    # }
    def create
    end
  end
end
