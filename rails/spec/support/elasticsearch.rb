RSpec.configure do |config|
  # Start an in-memory cluster for Elasticsearch as needed
  es_config = YAML.load_file('config/elasticsearch.yml')['test']
  es_bin = es_config['es_bin']
  es_port = es_config['port']

  config.before :all, elasticsearch: true do
    Elasticsearch::Extensions::Test::Cluster.start(command: es_bin, port: es_port.to_i, nodes: 1, timeout: 120) \
      unless Elasticsearch::Extensions::Test::Cluster.running?(command: es_bin, on: es_port.to_i)
  end

  # Stop elasticsearch cluster after test run
  config.after :suite do
    Elasticsearch::Extensions::Test::Cluster.stop(command: es_bin, port: es_port.to_i, nodes: 1)  \
      if Elasticsearch::Extensions::Test::Cluster.running?(command: es_bin, on: es_port.to_i)
  end

  # Create indexes for all elastic searchable models
  config.before :each, elasticsearch: true do
    ActiveRecord::Base.descendants.each do |model|
      next unless model.respond_to?(:__elasticsearch__)

      begin
        model.__elasticsearch__.create_index!
        model.__elasticsearch__.refresh_index!
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        # This kills "Index does not exist" errors being written to console
      rescue StandardError => e
        warn "There was an error creating the elasticsearch index for #{model.name}: #{e.inspect}"
      end
    end
  end

  # Delete indexes for all elastic searchable models to ensure clean state between tests
  config.after :each, elasticsearch: true do
    ActiveRecord::Base.descendants.each do |model|
      next unless model.respond_to?(:__elasticsearch__)

      begin
        model.__elasticsearch__.delete_index!
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        # This kills "Index does not exist" errors being written to console
      rescue StandardError => e
        warn "There was an error removing the elasticsearch index for #{model.name}: #{e.inspect}"
      end
    end
  end
end
