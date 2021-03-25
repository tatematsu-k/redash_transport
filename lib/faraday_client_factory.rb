require 'faraday'

class FaradayClientFactory
  def self.factory(**args)
    Faraday::Connection.new(**args) do |conn|
      conn.adapter Faraday.default_adapter
      conn.request :url_encoded
      conn.response :logger
      conn.headers['Content-Type'] = 'application/json'
    end
  end
end
