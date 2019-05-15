#####
#
# SearchSuggestion
#
# Provides suggestions while filling in forms
#
# Suggestions are created by running rake search_suggestions:index
# This calls the index_properties method which adds items ....
#
# Adds autosuggestion to forms - see properties.js.coffee.
# Code from Railscasts - not fully hooked up - requires indexing
# which needs to be automated.
# http://railscasts.com/episodes/102-auto-complete-association-revised
#
class SearchSuggestion < ApplicationRecord
  def self.terms_for prefix
    suggestions = where('term ilike ?', "#{prefix}_%")
    suggestions.order(popularity: :desc).limit(10).pluck(:term)
  end

  def self.index_properties
    Property.find_each do |property|
      index_term(property.address.house_name) if property.address.house_name
      index_term(property.address.road) if property.address.road
      index_term(property.address.town) if property.address.town
    end
  end

  def self.index_term term
    suggestion = where(term: term).first_or_create(popularity: 0)
    increment_counter(:popularity, suggestion.id)
  end
end
