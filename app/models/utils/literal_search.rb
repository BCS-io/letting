####
#
# LiteralSearch
#
# Responsible for exact match searches for the application.
#
# Used by search Controller
#
####
#
class LiteralSearch
  attr_reader :type, :query

  # type: the type, or model, of the query being executed - one of Client,
  #       Payment, Property or Arrear
  # query: the search terms being queried on the model
  #
  def self.search(type:, query:)
    new(type: type, query: query)
  end

  # go
  # Executes the query
  # returns LiteralResult - a wrapper for the search results
  #
  def go
    captured = type_query
    captured = default_ordered_query unless captured.concluded?
    captured
  end

  private

  def initialize(type:, query:)
    @type = type
    @query = query
  end

  def type_query
    case type
    when 'Client' then client(query)
    when 'Payment' then payment(query)
    when 'Property' then property(query)
    when 'Arrear', 'Cycle', 'User', 'InvoiceText', 'Invoicing'
      LiteralResult.missing
    else
      fail NotImplementedError, "Missing type: #{type}"
    end
  end

  def client query
    LiteralResult.new action: 'show',
                      controller: 'clients',
                      id: id_or_nil(Client.find_by_human_ref query)
  end

  def payment query
    LiteralResult.new action: 'new',
                      controller: 'payments',
                      id: id_or_nil(Account.find_by_human_ref query),
                      completes: true
  end

  def property query
    LiteralResult.new action: 'show',
                      controller: 'properties',
                      id: id_or_nil(Property.find_by_human_ref query)
  end

  def id_or_nil record
    record ? record.id : nil
  end

  def default_ordered_query
    return property(query) if property(query).concluded?
    return client(query) if client(query).concluded?

    LiteralResult.missing
  end
end
