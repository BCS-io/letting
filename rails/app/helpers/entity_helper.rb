###
#
# EntityHelper
#
# View logic over business, entity, object logic.
#
# View: entities/_form.html.erb
# Behaviour: reveal.js (js-reveal-link, js-hide-link & js-destroy-link)
#
####
#
module EntityHelper
  # Entity can have a number of parental association types
  # This will generate the type into a string so agents
  # and property can exist on the same page.
  #
  def entity_field_id entitieable, index
    "#{entitieable.class.to_s.underscore}_entity_#{index}"
  end
end
