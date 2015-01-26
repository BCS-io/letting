
####
#
# LinkHelper
#
# Shared helper methods
#
# rubocop: disable Metrics/LineLength, Metrics/MethodLength,  Metrics/ParameterLists
#
####
#
module LinkHelper
  def view_link model
    if model.new_record?
      app_link icon: 'file-o', size: '2x', disabled: true, title: 'View file'
    else
      app_link icon: 'file-o', size: '2x', path: model, title: 'View file'
    end
  end

  def edit_link model, size: '2x', title: title
    app_link icon: 'edit',
             size: size,
             path: [:edit, model],
             title: "Edit #{model.class.name}"
  end

  def add_link(icon: 'plus-circle', size: 'lg', path: '#', css: '', js_css: '', title:)
    app_link icon: icon, size: size, path: path, css: css, js_css: js_css, title: title
  end

  def delete_link path: '#',
                  js_css: '',
                  method: :delete,
                  data: true,
                  confirm: 'Are you sure you want to delete?',
                  title: 'Delete File',
                  disabled: false
    app_link icon: 'trash-o',
             path: path,
             method: method,
             js_css: js_css,
             data: data ? { confirm: confirm } : nil,
             title: title,
             disabled: disabled
  end

  def delete_charge(js_css:)
    app_link icon: 'trash-o', js_css: js_css, title: 'Delete charge'
  end

  # passing model object did not work.
  #
  def payment_link(path:)
    app_link icon: 'gbp', path: path, title: 'Add New Payment'
  end

  def print_link path:, title: 'Print'
    app_link icon: 'print', path: path, size: 'lg', title: title
  end

  def toggle_link direction:, size: 'lg', title: ''
    app_link icon: "chevron-circle-#{direction}",
             size: size,
             js_css: "js-toggle  #{hover direction: direction } ",
             title: title
  end

  #
  # None Standard links that we haven't called app_link on
  #

  def cancel_link(path:)
    link_to 'Cancel', path, class: 'warn'
  end

  # Used when there is no physical link to click on
  # In the case of index - grid row has no view button.
  #
  def testing_link(path:)
    link_to '', path, class: 'view-testing-link'
  end

  private

  def app_link(icon:,
               size: 'lg',
               path: '#',
               css: 'plain-button',
               js_css: '',
               data: nil,
               method: nil,
               title:,
               disabled: false)

    link_to fa_icon("#{icon} #{size}"),
            path,
            class: "hvr-grow  #{css}  #{js_css}",
            title: "#{title}#{disabled ? ' (disabled)' : '' }",
            method: method,
            data: data,
            disabled: disabled
  end

  def hover(direction:)
    direction == :down ? 'hvr-sink' : 'hvr-float'
  end
end
