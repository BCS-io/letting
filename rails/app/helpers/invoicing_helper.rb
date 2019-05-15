####
#
# InvocingHelper
#
#
####
#
module InvoicingHelper
  def default_date_link
    link_to " or default to the next #{Invoicing::WEEKS_AHEAD} weeks",
            '#',
            title: 'default dates',
            class: 'js-toggle  link-text-primary'
  end

  def choosing_dates_link
    link_to 'or choose dates',
            '#',
            title: 'Choose Dates with calendar',
            class: 'js-toggle  link-text-primary'
  end
end
