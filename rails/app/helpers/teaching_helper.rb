###
#
# TeachingHelper
#
####
#
module TeachingHelper
  # Payment Teaching Page
  #
  def pay_human_ref
    Account.first.property.human_ref
  end

  def pay_owner owner: Account.first.holder
    link_to 'owner',
            search_path(search_terms: owner, search_model: 'Payment')
  end

  # TODO: search is not working
  #
  def pay_amount amount: Payment.first.amount
    link_to 'amount',
            search_path(search_terms: amount, search_model: 'Payment')
  end
end
