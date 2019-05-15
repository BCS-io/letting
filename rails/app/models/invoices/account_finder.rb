#
# AccountFinder
# Convert property_range into account id
#
class AccountFinder
  attr_reader :matching
  def initialize(property_range:)
    @matching = Account.between?(property_range).includes(account_includes)
  end

  #
  # To avoid n+1 problems when loading Account from the database
  #
  def account_includes
    [[property: property_includes], :credits, :charges, :debits]
  end

  def property_includes
    [:address, client: [:address], agent: [:address]]
  end
end
