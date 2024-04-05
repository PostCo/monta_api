# frozen_string_literal: true

module MontaAPI
  class ReturnForecastResource < Resource
    # @client.return_forecast.find_by(code: "2")
    def find_by(code:)
      response_body = get_request("returnforecast/#{code}").body

      ReturnForecast.new(response_body)
    end
  end
end
