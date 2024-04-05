# frozen_string_literal: true

module MontaAPI
  class Error < StandardError
  end

  class NotFoundError < Error
  end

  class WhiteListError < Error
  end

  class AuthenticationError < Error
  end

  class ServerError < Error
  end

  class RateLimitError < Error
  end
end
