
####
#
# LinkHelper
#
# Shared helper methods
#
# rubocop: disable Metrics/LineLength, Metrics/MethodLength,  Metrics/ParameterLists, Metrics/ModuleLength
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

  def edit_link model, size: '2x'
    app_link icon: 'edit',
             size: size,
             path: [:edit, model],
             title: "Edit #{model.class.name}"
  end

  def add_link(icon: 'plus', size: 'lg', path: '#', css: '', js_css: '', title:)
    app_link icon: icon, size: size, path: path, css: "Button  ButtonIcon  #{css}", js_css: js_css, title: title
  end

  def delete_charge css: '', js_css:, title: 'Delete Charge'
    delete_link method: nil, css: css, js_css: js_css, data: false, title: title
  end

  def delete_link text: '',
                  id: nil,
                  path: '#',
                  css: '',
                  js_css: '',
                  method: :delete,
                  data: true,
                  confirm: 'Are you sure you want to delete?',
                  title: 'Delete File',
                  disabled: false
    app_link icon: 'trash-o',
             text: text,
             id: id,
             path: path,
             css: "Button ButtonIcon  #{css}",
             js_css: js_css,
             method: method,
             data: data ? { confirm: confirm } : nil,
             title: title,
             disabled: disabled
  end

  # passing model object did not work.
  #
  def payment_link(path:)
    app_link icon: 'gbp', path: path, title: 'Add New Payment'
  end

  def print_link text: '', id: nil, path:, css: 'Button  ButtonIcon', title: 'Print', disabled: false
    app_link icon: 'print',
             id: id,
             text: text,
             path: path,
             css: css,
             title: title,
             disabled: disabled
  end

  def chevron_link(direction:, text: '', path: '#', title:)
    app_link icon: "chevron-#{direction}",
             text: text,
             direction: direction == 'right',
             path: path,
             title: title,
             disabled: path ? false : true
  end

  def toggle_link direction:, size: 'lg', title: ''
    app_link icon: "chevron-circle-#{direction}",
             size: size,
             js_css: "js-toggle  #{hover direction: direction} ",
             title: title
  end

  #
  # None Standard links that we haven't called app_link on
  #

  def cancel_link(path:)
    link_to 'Cancel', path, class: 'text-warn'
  end

  # Used when there is no physical link to click on
  # In the case of index - grid row has no view button.
  #
  def testing_link(path:)
    link_to '', path, class: 'link-view-testing'
  end

  private

  def app_link(icon:,
               size: 'lg',
               text: '',
               direction: false,
               path: '#',
               id: nil,
               css: 'Button  ButtonIcon',
               js_css: '',
               data: nil,
               method: nil,
               title:,
               disabled: false)
    if disabled == false
      link_to fa_icon("#{icon} #{size}", text: text, right: direction),
              path,
              id: id,
              class: "#{hover_grow(disabled: disabled)}  #{css}  #{js_css}",
              title: title,
              method: method,
              data: data,
              disabled: disabled
    else
      link_to fa_icon("#{icon} #{size}", text: text, right: direction),
              '#',
              id: id,
              class: css,
              disabled: true,
              title: "#{title} (disabled)"
    end
  end

  def hover_grow(disabled:)
    return '' if disabled

    'hvr-grow'
  end

  def hover(direction:)
    direction == :down ? 'hvr-sink' : 'hvr-float'
  end
end
