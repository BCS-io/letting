####
#
# A property, under management by the letting company.
#
# Properties have an account. They have tenants (see contact module),
# Agents responsible for account charges ( the agent). Money
# collected goes to the properties client.
#
# The code is part of the representation of a property.
#
# rubocop: disable Lint/UnusedMethodArgument
####
#
class Property < ActiveRecord::Base
  include StringUtils
  belongs_to :client
  has_one :account, dependent: :destroy, inverse_of: :property
  accepts_nested_attributes_for :account, allow_destroy: true
  include Contact
  has_one :agent, dependent: :destroy, inverse_of: :property
  accepts_nested_attributes_for :agent, allow_destroy: true

  validates :human_ref, numericality: true, uniqueness: true
  validates :client, :agent, :entities, presence: true
  before_validation :clear_up_form

  delegate :abridged_text, to: :address
  delegate :bill_to, to: :agent
  delegate :full_names, to: :entities
  delegate :text, to: :address, prefix: true

  MAX_HOUSE_HUMAN_REF = 5_999

  def occupiers
    full_names
  end

  def prepare_for_form
    prepare_contact
    build_agent if agent.nil?
    agent.prepare_for_form
    build_account if account.nil?
    account.prepare_for_form
  end

  def clear_up_form
    entities.clear_up_form
    account.clear_up_form if account.present?
  end

  def invoice billing_period: nil
    {
      property_ref: human_ref,
      occupiers: occupiers,
      property_address: to_address,
      billing_address: bill_to_s,
      client_address: client.to_s,
    }
  end

  def to_billing
    address.name_and_address name: occupiers
  end

  def next
    Property.find_by('human_ref > ?', human_ref)
  end

  def prev
    Property.where('human_ref < ?', human_ref).last
  end

  include Searchable
  # Elasticsearch uses generates JSON document for property index
  def as_indexed_json(_options = {})
    as_json(
      methods: [:occupiers, :address_text],
      include: {
        agent: { methods: [:full_name, :to_address],
                 only: [:full_name, :to_address] }
      },
      except: [:id, :created_at, :updated_at]
    )
  end

  def self.find_by_human_ref human_ref
    return nil unless num? human_ref

    find_by human_ref: human_ref
  end

  def self.by_human_ref
    order(:human_ref)
  end

  def self.houses
    where("human_ref <= #{MAX_HOUSE_HUMAN_REF}")
  end

  def self.quarter_day_in month
    joins(account: [charges: [cycle: [:due_ons]]])
      .where('due_ons_count = 2 AND month = ?', month)
  end

  private

  def to_address
    return unless address
    address.text
  end

  def bill_to_s
    agent.bill_to.to_billing
  end
end
