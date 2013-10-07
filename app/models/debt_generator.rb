####
#
# DebtGenerator
#
# Why does the class exist?
#
# To search a group of properties for charges that are due and generate
# the debts.
#
# How does it fit into the larger system?
#
# Coverts due charges into debts. The debts are then used for invoicing
# owning debts and later payments.
#
####
#
class DebtGenerator < ActiveRecord::Base
  has_many :debts, -> { uniq }
  attr_accessor :properties
  accepts_nested_attributes_for :debts
  validates :search_string, uniqueness: { scope: [:start_date, :end_date] },
                            presence: true
  validates :properties, presence: true
  validates :debts, presence: true

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates_with DateEqualOrAfter

  scope :latest_debt_generated,
        ->(limit) { order(created_at: :desc).limit(limit) }

  after_initialize do |debt_generator|
    self.start_date = default_start_date if start_date.blank?
    self.end_date = default_end_date if end_date.blank?
  end

  def display_search_string
    "Searched for: #{search_string} Date Range: #{start_date} - #{end_date}"
  end

  def generate
    properties.each do |property|
      chargeable_to_debt property
                         .account
                         .chargeables_between(start_date..end_date)
    end
    new_debts
  end

  def debtless?
    debts.empty?
  end

  def == other
    search_string == other.search_string &&
    start_date == other.start_date &&
    end_date == other.end_date
  end

  def properties
    @properties ||= Property.search_min(search_string)
  end

  private

  def chargeable_to_debt chargeable_infos
    chargeable_infos.each { |chargeable| debts.build chargeable.to_hash }
  end

  def default_start_date
    Date.current
  end

  # You need to give a month's notice to bill for a charge (make a debt)
  # You don't want to bill into next months
  # Most printouts are done a month before.
  def default_end_date
    Date.current + 8.weeks
  end

  def new_debts
    debts.select(&:new_record?)
  end

end
