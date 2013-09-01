class Property < ActiveRecord::Base
  belongs_to :client
  include Contact
  include Charges
  accepts_nested_attributes_for :charges, allow_destroy: true
  has_one :billing_profile, dependent: :destroy, inverse_of: :property

  accepts_nested_attributes_for :billing_profile, allow_destroy: true

  validates :human_id, :client_id, numericality: true
  validates :human_id, uniqueness: true
  validates :entities, presence: true
  before_validation :clear_up_after_form

  def prepare_for_form
    prepare_contact
    self.build_billing_profile if self.billing_profile.nil?
    billing_profile.prepare_for_form
    charges.prepare
  end

  def clear_up_after_form
    entities.clean_up_form
    charges.clean_up_form
  end

  def separate_billing_address
    billing_profile.use_profile
  end
  alias_method :separate_billing_address?, :separate_billing_address

  def separate_billing_address separate
    billing_profile.use_profile = separate
  end

  def bill_to
    billing_profile.bill_to
  end

  def self.search_by_house_name(search)
    Property.includes(:address).where('addresses.house_name LIKE ?', "#{search}").references(:address)
  end

  def self.search search
    if search.blank?
       Property.all.includes(:address)
    else
      self.search_by_all(search)
    end
  end

  private
    def self.search_by_all(search)
      Property.includes(:address,:entities).
        where('human_id = ? OR ' + \
              'entities.name ILIKE ? OR ' + \
              'addresses.house_name ILIKE ? OR ' + \
              'addresses.road ILIKE ? OR '  \
              'addresses.town ILIKE ?',  \
              "#{search.to_i}", "#{search}%", "#{search}%", "#{search}%", "#{search}%" \
              ).references(:address, :entity)
    end

end
