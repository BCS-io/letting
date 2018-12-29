# Code from SO
# http://stackoverflow.com/questions/13187753/   \
#  rails3-jquery-autocomplete-how-to-test-with-rspec-and-capybara
#
# Error - can't find autocomplete selection =>
# "expected to find css "ul.ui-autocomplete li.ui-menu-item a"
# but there were no matches"
#
# View Logic
#
# <%= text_field_tag nil, "#{property.client.try(:human_ref)}
#     #{property.client.try(:entities).try(:full_name)}",
#       :id => 'property_client_ref',
#       data: { autocomplete_source: Client.order(:human_ref)
#                  .map { |t| { :label => "#{t.human_ref}
#                   #{t.full_name}", :value => t.id } } } %>
# <%= f.hidden_field :client_id, id: 'client_id' %>
#
# SpecHelper
#
# RSpec.configure do |config|
#  config.include CapybaraHelper
# end
#
# Rspec
#
# fill_autocomplete('property_client_ref', with: client_id)
#
module CapybaraHelper
  def fill_autocomplete(field, with: '', select: '')
    fill_in field, with: with

    page.execute_script %{ $('##{field}').trigger('focus') }
    page.execute_script %{ $('##{field}').trigger('keydown') }
    selector = %{ul.ui-autocomplete li.ui-menu-item a:contains("#{select}")}

    expect(page).to have_selector('ul.ui-autocomplete li.ui-menu-item a')
    page.execute_script %{ $('#{selector}').trigger('mouseenter').click() }
  end
end
