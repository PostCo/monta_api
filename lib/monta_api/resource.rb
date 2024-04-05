# frozen_string_literal: true

module MontaAPI
  class Resource
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def get_request(url, params: {}, headers: {})
      handle_response client.connection.get(url, params, headers)
    end

    def post_request(url, body:, headers: {})
      handle_response client.connection.post(url, body, headers)
    end

    def put_request(url, body:, headers: {})
      handle_response client.connection.put(url, body, headers)
    end

    def handle_response(response)
      error_message = response.body

      case response.status
      when 400
        raise Error, "A bad request or a validation exception has occurred. #{error_message}"
      when 401
        raise AuthenticationError, "Invalid authorization credentials. #{error_message}"
      when 403
        raise WhiteListError, "IP address is not white listed. #{error_message}"
      when 404
        raise NotFoundError, "The resource you have specified cannot be found. #{error_message}"
      when 429
        raise RateLimitError, "The API rate limit for your application has been exceeded. #{error_message}"
      when 500
        raise ServerError, "An unhandled error with the Monta API. #{error_message}"
      end

      response
    end
  end
end
