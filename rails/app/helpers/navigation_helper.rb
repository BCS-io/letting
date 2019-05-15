####
#
# Navigation
#
# Uses styles to display the menu according to state.
# Main Menu - is a menu within the accordion.
# active-menu, inactive-menu - are different styles
#
# active-item - the menu CSS applied to the item for the current page we are on
# inactive-item - the default CSS applied to every item not selected (all but 1)
#
# controller_name is a constant, converted from the class name
#
####
#
module NavigationHelper
  # main_menu_active?
  #
  def main_menu_active? controllers
    if controller_name.in? controllers
      'active-menu'     # Menu items displayed
    else
      'inactive-menu'   # Menu items hidden (no css)
    end
  end

  # current_path
  # Is page's path the current_page?
  # returns true if the path is eq to current path
  # returns false if the path is not eq to the current path
  #
  def current_path? path
    if current_page? path
      'active-item'   # css
    else
      'inactive-item' # no css
    end
  end
end
