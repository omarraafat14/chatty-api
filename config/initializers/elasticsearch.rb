Elasticsearch::Model.client = Elasticsearch::Client.new(url: ENV.fetch("ELASTICSEARCH_URL") { "elasticsearch:9200" })
