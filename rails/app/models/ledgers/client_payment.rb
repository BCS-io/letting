# ClientPayment
#
# Returns the payments made to a client for house ground rent.
#
# Clients have a number of properties that ground rent are charged on.
# When a tenant pays money for this charge the client gets this money
# minus handling fees.
#
# Houses are either divided into Mar/Sep and Jun/Dec. So, for each house
# payments are broken into 6 month periods starting either Mar and Sep or
# Jun and Dec - periods are always started on the 1st day of the month.
#
#
# Client Payment uses an Ajax Request
#
# Got Ajax request by using: GoRails
# https://gorails.com/episodes/jquery-ujs-and-ajax
#
# 1) Create an additional route which Ajax can query the back-end with.
#
# resources :clients do
#   member do
#     patch :payment
#   end
# end
#
#
# 2) Add a link to the additional patched route
#
# _account_heading.erb
#
# client_payment_path(client_id, year: year, month: month)
# link_to 'my ajax', payment_client_path(client_id, year: year, month: month)
#                  , method: :patch
#                  , remote: true
#
# This create a link: data-method="patch" and href="/clients/5/payment?.."
#
#
# 3) This is applied an action on the clients_controller
#
# class ClientsController < ApplicationController
#   def payment
#     @client_payment  = ( new assignment to be redisplayed )
#   end
#
#
# 4) The link_to is a remote Ajax call which is satisfied by: payment.js.erb
#
# views/clients/payment.js.erb
#
# $('.js-payment-details').html("<%= escape_javascript(render partial:
#   "client_payments/client_payment",
#   locals: { client_payment: @client_payment }) %>");
#
#
# 5) Add link which the Ajax will add content to:
#    <div class='js-payment-details'>
#      content written here
#    </div>
#
class ClientPayment
  attr_reader :client_id, :year, :month

  def initialize(client_id:)
    @client_id = client_id
  end

  def self.query(client_id: 1)
    new(client_id: client_id)
  end

  # the client object of used to initialize
  #
  def client
    @client ||= Client.includes(properties: [:address]).find client_id
  end

  def details(year:, month:)
    @year = year
    @month = month
  end

  # Arbitrary range of years of payments to cover
  #
  def years
    Time.zone.now.year.downto(Time.zone.now.year - 4).map(&:to_s)
  end

  # Accounts which include a particular batch_month:
  #
  # Arg:
  # batch_months: - period which payments are summed over
  #               - either Mar/Sep or Jun/Dec
  # returns: accounts (actually relations) which have charges in Mar/Sep
  #          or Jun/Dec
  #          - accounts can be in one, both, or neither.
  #
  def accounts_with_period(batch_months:)
    Account.joins(:property)
           .merge(client.properties.houses.quarter_day_in(batch_months.first))
           .order('properties.human_ref ASC')
  end

  # client payments summed for all accounts for a year given batch_month
  #
  # year:    - the year the payments will be summed over
  # month:   - the period of payment governed by start month
  #
  def period_totals(year:, batch_months:)
    Payment.by_quarter_day(year: year, batch_months: batch_months)
           .where(account_id: accounts_with_period(batch_months: batch_months)
        .pluck(:account_id))
           .pluck(:amount).sum
  end
end
