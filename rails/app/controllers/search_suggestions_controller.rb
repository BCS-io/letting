#####
#
# SearchSuggestionsController
#
# Controller for handling autocomplete messages.
#
#
class SearchSuggestionsController < ApplicationController
  def index
    render json: SearchSuggestion.terms_for(params[:term])
  end
end
