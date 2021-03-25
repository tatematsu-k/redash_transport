require 'dotenv/load'
require './lib/redash_client'

source_client = RedashClient.source_client
target_client = RedashClient.target_client

# "{data_source_id of source}": {data_source_id of target}
datasource_map = { "1" => 1 }

source_queries =
  source_client
    .get_queries
    .fetch("results")
    .select { |res| !res["is_archived"] && !res["is_draft"] }

puts "============="
puts "target query:"
p source_queries.to_json

puts "============="
source_queries.each do |source_res|
  source_data_source_id = source_res["data_source_id"]
  target_data_source_id = datasource_map[source_data_source_id.to_s]
  p "source_data_source_id: #{source_data_source_id}"
  p "target_data_source_id: #{target_data_source_id}"
  query = source_res.slice("schedule", "description", "query", "name").merge("data_source_id": target_data_source_id)
  p target_client.post_query(**query)
end
