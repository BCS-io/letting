####
#
# LiteralSearch
#
# Responsible for exact match searches for the application.
#
# Used by search Controller - returns results as LiteralResults
#
#
####
#
class LiteralSearch
  attr_reader :referrer, :query

  # referrer: the model and action of the query being executed - one of Client,
  #           Payment, Property, Arrear or Invoice and any of the actions.
  # query: the search terms being queried on the model
  #
  def self.search(referrer:, query:)
    new(referrer: referrer, query: query)
  end

  # go
  # Executes the query
  # returns LiteralResult - a wrapper for the search results
  #
  def go
    return query_by_referrer if query_by_referrer.found?

    default_ordered_query
  end

  private

  def initialize(referrer:, query:)
    @referrer = referrer
    @query = query
  end

  # query_by_referrer
  #   - cache method
  #
  def query_by_referrer
    @query_by_referrer ||= get_query_by_referrer
  end

  # get_query_by_referrer
  #  - search depending on the request's original controller
  #
  def get_query_by_referrer
    case referrer.controller
    when 'clients' then client_search
    when 'payments', 'payments_by_dates' then payment_search

    when 'properties' then property_search
    when 'arrears', 'cycles', 'users', 'invoice_texts', 'invoicings', 'invoices'
      results records: []

    else
      raise NotImplementedError, "Missing: #{referrer}"
    end
  end

  def client_search
    results action: 'show',
            controller: 'clients',
            records: Client.match_by_human_ref(query)
  end

  def payment_search
    results action: 'index',
            controller: 'payments',
            records: Payment.includes(account: [property: [:entities]])
                            .match_by_human_ref(query)
                            .by_booked_at.to_a
  end

  def property_search
    results action: 'show',
            controller: 'properties',
            records: Property.match_by_human_ref(query)
  end

  # default_ordered_query
  #  - when we don't find anything under the initial controller we check if
  #    it would have matched literal searches in other important controllers
  #    before giving up.
  #
  #    returns literal search matches for the query
  #
  def default_ordered_query
    return property_search if property_search.found?
    return client_search if client_search.found?

    results records: []
  end

  def results(action: '', controller: '', records:)
    LiteralResult.new action: action, controller: controller, records: records
  end
end
