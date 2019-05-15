####
#
# Entities
#
# Why does this class exist?
#
# Adds methods to an association of entities;
#
# How does this fit into the larger system?
#
# Part of the Contact module which is used in a number of classes
# - property, client and agent. It holds a collection
# of entity objects.
####
#
module Entities
  include EntitiesDefaults
  extend ActiveSupport::Concern
  included do
    has_many :entities, -> { order(:created_at) }, dependent: :destroy,
                                                   as: :entitieable do
      def full_names
        reject(&:empty?).map(&:full_name).join(' & ')
      end

      def prepare
        (size...MAX_ENTITIES).each { build }
        each(&:prepare)
      end

      def clear_up_form
        each(&:clear_up_form)
      end

      def destroy_all
        each(&:destroy_form)
      end
    end
    validate :maximum_entities

    def maximum_entities
      return if entities.blank?

      errors.add(:entities, 'Too many entities') if entities.size > MAX_ENTITIES
    end
  end
end
