require 'JSON'
require './lib/faraday_client_factory'

class RedashClient
  attr_accessor :faraday_client
  attr_accessor :api_key

  def initialize(faraday_client:, api_key:)
    @faraday_client = faraday_client
    @api_key = api_key
  end

  def get_queries
    get('/api/queries')
  end

  def post_query(...)
    post('/api/queries', ...)
  end

  private

  def get(path, **args)
    res = faraday_client.get(path, **args) do |req|
      req.headers['Authorization'] = "Key #{api_key}"
    end
    JSON.parse(res.body)
  end

  def post(path, **args)
    puts "params:"
    puts args.to_json
    res = faraday_client.post(path) do |req|
      req.headers['Authorization'] = "Key #{api_key}"
      req.body = args.to_json
    end
    JSON.parse(res.body)
  end

  def self.source_client
    @@source_client ||=
      new(
        faraday_client: FaradayClientFactory.factory(url: ENV['SOURCE_REDASH_ENDPOINT']),
        api_key: ENV['SOURCE_REDASH_API_KEY'],
      )
  end

  def self.target_client
    @@target_client ||=
      new(
        faraday_client: FaradayClientFactory.factory(url: ENV['TARGET_REDASH_ENDPOINT']),
        api_key: ENV['TARGET_REDASH_API_KEY'],
    )
  end
end
