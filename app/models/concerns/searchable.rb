####
#
# Searchable
#
# Configures the Elasticsearch searching method
#
# Adds a 'search' method to any class it is included into allowing full text search
#   - currently Client, Payment and Property.
#
# NGrams don't always seem to work - seems to occasional match whole word but
# not the ngrame (so for London: matches London and not Lond)
#
# To sync Elasticsearch with main database:
# rake elasticsearch:sync
#
# def self.search(query, sort)
# The code comes from the issue request:
# https://github.com/elasticsearch/elasticsearch-rails/issues/206
#
# rubocop: disable Metrics/MethodLength
#
####
#
module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    # collection is pluralized version of the model_name
    index_name [Rails.env, model_name.collection.tr('/', '-')].join('_')

    after_commit on: %i[create update] do
      __elasticsearch__.index_document
    end

    after_commit on: [:destroy] do
      __elasticsearch__.delete_document
    end

    settings(
      index: {
        analysis: {
          filter: {
            nGram_filter: {
              type: 'nGram',
              min_gram: 1,
              max_gram: 15,
              token_chars: %i[letter digit punctuation symbol]
            }
          },
          analyzer: {
            nGram_analyzer: {
              type: 'custom',
              tokenizer: 'whitespace',
              filter: %i[lowercase asciifolding nGram_filter]
            },
            whitespace_analyzer: {
              type: 'custom',
              tokenizer: 'whitespace',
              filter: %i[lowercase asciifolding]
            }
          }
        },
        number_of_shards: 1
      }
    )

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

    # The search code follows code I found in Elasticsearch issue
    # (see above)
    #
    def self.search(query, sort: '')
      @search_definition = {
        query: {},
        filter: {}
      }

      if query.blank?
        @search_definition[:query] = { match_all: {} }
        @search_definition[:size]  = 100
        @search_definition[:sort]  = [
          { sort.to_sym => { order: 'asc' } }
        ]
      else
        @search_definition[:query] = {
          match: {
            _all: {
              query: query,
              operator: 'and'
            }
          }
        }
        @search_definition[:sort] = [{
          _score: { order: 'desc' },
          sort.to_sym => { order: 'asc' }
        }]
        @search_definition[:size] = 100
      end
      __elasticsearch__.search(@search_definition)
    end
  end
end

# Console Management
#
# Full re-import
# rake elasticsearch:sync
#
# Read
# GET /development_properties/_settings
# rails c; Property.settings.to_hash
# GET /development_properties/_mapping
# rails c; pp Property.mappings.to_hash
#
# Update (Refresh)
# Property.__elasticsearch__.refresh_index!
#
# Delete
# Property.__elasticsearch__.delete_index!

# Import Data
# Property.import
