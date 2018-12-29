####
#
# module Contact
#
# The system follows entities with an address this wraps up the relationship
#
# Contact is used by Property, Client and Agent.
# Contact includes entities and an address.
####
#
module Contact
  extend ActiveSupport::Concern
  include Entities
  included do
    accepts_nested_attributes_for :entities, allow_destroy: true,
                                             reject_if: :all_blank
    has_one :address, class_name: 'Address',
                      dependent: :destroy,
                      as: :addressable
    accepts_nested_attributes_for :address, allow_destroy: true
  end

  private

  def prepare_contact
    prepare_address if address.nil?
    entities.prepare
  end

  def prepare_address
    build_address
  end
end
