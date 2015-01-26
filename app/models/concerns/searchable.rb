####
#
# Searchable
#
# Configures the Elasticsearch searching method
#
# Adds a 'search' method to any class it is included into allowing full-text
# search - currently only used in Client and Property.
#
# NGrams don't always seem to work - seems to occasional match whole word but
# not the ngrame (so for London: matches London and not Lond)
#
# Always works (see also Readme):
# rails c
# Property.import force: true, refresh: true
# Client.import force: true, refresh: true
# Payment.import force: true, refresh: true
#
####
#
module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    # collection is pluralized version of the model_name
    index_name [Rails.env, model_name.collection.gsub(/\//, '-')].join('_')

    settings(
      index: {
        analysis: {
          filter: {
            nGram_filter: {
              type: 'nGram',
              min_gram: 2,
              max_gram: 15,
              token_chars: [:letter, :digit, :punctuation, :symbol]
            }
          },
          analyzer: {
            nGram_analyzer: {
              type: 'custom',
              tokenizer: 'whitespace',
              filter: [:lowercase, :asciifolding, :nGram_filter]
            },
            whitespace_analyzer: {
              type: 'custom',
              tokenizer: 'whitespace',
              filter: [:lowercase, :asciifolding]
            }
          }
        },
        number_of_shards: 1
      }
    )

    # https://github.com/elasticsearch/elasticsearch-rails/issues/206

    mapping _all: { index_analyzer: :nGram_analyzer,
                    search_analyzer: :whitespace_analyzer } do
      indexes :human_ref, type: :integer, boost: 2.0, index: :not_analyzed
      indexes :occupiers, type: :string
      indexes :address do
        indexes :created_at, index: :not_analyzed
        indexes :updated_at, index: :not_analyzed
      end

      indexes :created_at, index: :not_analyzed
      indexes :updated_at, index: :not_analyzed
    end

    def self.search(query, sort)
      @search_definition = {
        query: {},
        filter: {},
      }

      unless query.blank?
        @search_definition[:query] = {
          match: {
            _all: {
              query: query,
              operator: 'and'
            }
          }
        }
        @search_definition[:size]  = 100
      else
        @search_definition[:query] = { match_all: {} }
        @search_definition[:size]  = 100
      end
      __elasticsearch__.search(@search_definition)
    end
  end
end

# Console Management
#
# Create
# Property.__elasticsearch__.create_index! force: true
# Create None-standard index
# Property.__elasticsearch__.client.indices.create  index: Property.index_name,
#   body: { settings: Property.settings.to_hash,
#            mappings: Property.mappings.to_hash }
#
# Read
# GET /properties/_settings
# Property.settings.to_hash
# GET /properties/_mapping
# pp Property.mappings.to_hash
#
# Update (Refresh)
# Property.__elasticsearch__.refresh_index!
#
# Delete
# Property.__elasticsearch__.delete_index!

# Import Data
# Property.import
