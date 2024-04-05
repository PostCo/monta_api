# frozen_string_literal: true

require "faraday"

module MontaAPI
  class Client
    BASE_URL = "https://api-v6.monta.nl/"

    attr_reader :username, :password, :adapter

    def initialize(username:, password:, adapter: Faraday.default_adapter)
      @username = username
      @password = password
      @adapter = adapter
    end

    def return
      ReturnResource.new(self)
    end

    def return_forecast
      ReturnForecastResource.new(self)
    end

    def connection
      @connection ||= Faraday.new do |conn|
        conn.url_prefix = BASE_URL
        conn.request :json
        conn.response :json, content_type: "application/json"
        conn.adapter adapter
        conn.request :authorization, :basic, username, password
      end
    end
  end
end
