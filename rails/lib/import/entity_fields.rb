require_relative '../modules/method_missing'
require_relative 'errors'

module DB
  ####
  #
  # EntityFields
  #
  # Wraps around the entity fields used in a row.
  #
  # Entity row provides an interface to fields used for importing contact
  # rows (contact rows are found in agent (import_agent), client(import_client)
  # and property data (import_property).
  #
  ####
  #
  class EntityFields
    def initialize title, initials, name
      @title = top_punctuation(title.to_s).strip
      @initials = initials.to_s.strip
      @name = name ? tail_punctuation(name).strip : ''
    end

    def title
      @title || ''
    end

    def initials
      @initials || ''
    end

    def name
      person? ? @name : [@initials, @name].join(' ')
    end

    def person?
      (@title.present? || @initials.present?) && @name.exclude?('Ltd')
    end

    def update_for entity
      entity.attributes = attributes
    end

    private

    def attributes
      {
        title: title,
        initials: initials,
        name: name
      }
    end

    def top_punctuation sanitize
      sanitize.sub(/^[,&-]?/, '')
    end

    def tail_punctuation sanitize
      sanitize.sub(/[,&]?$/, '')
    end
  end
end
