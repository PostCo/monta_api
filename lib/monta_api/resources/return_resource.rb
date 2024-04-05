# frozen_string_literal: true

module MontaAPI
  class ReturnResource < Resource
    # @client.return.where(since: "2024-04-05", status: "any")
    # Response:
    # {
    # 	"Returns": [
    # 		{
    # 			"Id": 3873210,
    # 			"CreatedAt": "2024-04-05T08:40:40.327",
    # 			"Comment": null,
    # 			"Cause": "Ik ben van gedachten veranderd",
    # 			"WebshopCause": null,
    # 			"WebshopOrderId": "1173",
    # 			"Lines": [
    # 				{
    # 					"WebshopOrderLineId": "14638817116463",
    # 					"Sku": "ABC",
    # 					"ReturnedQuantity": 1,
    # 					"Sellable": true,
    # 					"FollowedUpMontapacking": false,
    # 					"FollowedUpCustomer": false,
    # 					"FollowedUpAction": null,
    # 					"Cause": "Ik ben van gedachten veranderd",
    # 					"Comment": null,
    # 					"BatchCode": null
    # 				}
    # 			],
    # 			"UpdatedAt": "2024-04-05T08:41:33.81",
    # 			"SerialNumbers": [],
    # 			"ReturnForecastId": 2361500,
    # 			"ForecastCode": "2"
    # 		}
    # 	]
    # }
    def where(since:, status: "any")
      response_body = get_request("return/updated_since/#{since}", params: { status: status }).body

      response_body["Returns"].map { |attributes| Return.new(attributes) }
    end
  end
end
