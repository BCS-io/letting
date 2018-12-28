####
#
# Payment
#
# When a payment is received from a tenant it is represented by the payment
# object on the database.
#
# Payments are a collection of credits which offset against debits.
#
####
#
class Payment < ActiveRecord::Base
  belongs_to :account, inverse_of: :payments
  has_many :credits, inverse_of: :payment, dependent: :destroy do
    def clear_up
      each(&:clear_up)
    end

    def register_booking payment
      each { |credit| credit.register_booking(payment) }
    end
  end
  after_initialize :init
  before_validation :clear_up

  accepts_nested_attributes_for :credits, allow_destroy: true
  validates :account, :booked_at, presence: true
  validates :amount, price_bound: true

  def init
    self.amount = 0 if amount.blank?
    self.booked_at = Time.zone.now if booked_at.blank?
  end

  def account_exists?
    account.present?
  end

  def prepare
    return unless account_exists?
    credits.push(*account.make_credits)
  end

  # register_booking
  #
  # record the booked_at time.
  #   - form attributes come with booked_at as a date without a time.
  #     if the date is today we add the current time on.
  def register_booking
    return unless booked_at

    self.booked_at = ClockIn.new.recorded_as booked_time: booked_at.to_date,
                                             add_time: true
    credits.register_booking(self)
  end

  scope :by_booked_at, -> { order(booked_at: :desc) }

  # Search for payments booked on this date
  # booked_on - is the date you want a payment to appear in the accounts
  #             user settable.
  #
  def self.booked_on date: Time.zone.today.to_s
    return Payment.none unless SearchDate.new(date).valid_date?

    Payment.includes(account: [:property])
           .where(booked_at: SearchDate.new(date).day_range)
  end

  # Search for payments created on this date.
  # created_on - is the date a payment was created - not user settable.
  #
  def self.created_on date: Time.zone.today.to_s
    return Payment.none unless SearchDate.new(date).valid_date?

    Payment.includes(account: [:property])
           .where(created_at: SearchDate.new(date).day_range)
  end

  def self.recent after_date: (Time.zone.now - 2.years).to_date
    where('booked_at > ?', after_date)
  end

  def self.by_booked_at_date
    order('DATE(booked_at) desc').group('DATE(booked_at)')
                                 .pluck('DATE(booked_at) as booked_on,'\
             ' count(amount) as payments_count, ' \
             ' sum(amount) as payment_sum')
  end

  # The date a payment was last booked_at
  # booked_at is an accounting date and does not have to be the created_at date.
  #
  def self.last_booked_at
    return Time.zone.today.to_s if Payment.count.zero?
    Payment.order('booked_at DESC').first.booked_at.to_date.to_s
  end

  # The date a payment was last created_at
  # created_at - is the date a payment was entered and is unaffected by any
  #              booked_at date.
  #
  def self.last_created_at
    return :no_last_payment if Payment.count.zero?
    Payment.order('created_at DESC').first
  end

  # human_ref - the id of the account / property to return
  #
  def self.human_ref human_ref
    Payment.includes(account: [:property])
           .where(properties: { human_ref: human_ref })
  end

  # payments are grouped on which quarter day to apply them to
  #   - quarter day is the domain name for dates that happen in Mar/Jun/Sep/Dec
  #   - Typically around the 21st of the month but can vary
  #   - payments begin to be applied to the quarter day a month before the
  #     actual date
  #
  # year:         - the year the payments will be summed over
  # batch_months: - period which payments are summed over
  #
  def self.by_quarter_day(year:, batch_months:)
    period = batch_months.payment_period(year: year)
    where(booked_at: period.first.beginning_of_day..period.last.end_of_day)
  end

  include Searchable
  # Elasticsearch uses generates JSON document for payment index
  def as_indexed_json(_options = {})
    as_json(
      include: {
        account: { methods: [:human_ref, :holder, :address] }
      })
  end

  private

  def clear_up
    credits.clear_up
  end
end
