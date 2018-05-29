module Admin
  module BaseHelper
    def flash_alert flash
      if flash.present?
        close_button = button_tag(class: 'close', 'data-dismiss' => 'alert', 'aria-label' => t(:close)) do
          content_tag('span', '&times;'.html_safe, 'aria-hidden' => true)
        end
        message = flash[:error] || flash[:notice] || flash[:success]
        flash_class = "danger" if flash[:error]
        flash_class = "info" if flash[:notice]
        flash_class = "success" if flash[:success]
        flash_div = content_tag(:div, (close_button + message), class: "alert alert-#{flash_class} alert-auto-disappear")
        content_tag(:div, flash_div, class: 'col-md-12')
      end
    end

    def field_container(model, method, options = {}, &block)
      css_classes = options[:class].to_a
      css_classes << 'field'
      if error_message_on(model, method).present?
        css_classes << 'withError'
      end
      content_tag(:div, capture(&block), class: css_classes.join(' '), id: "#{model}_#{method}_field")
    end

    def error_message_on(object, method, options = {})
      object = convert_to_model(object)
      obj = object.respond_to?(:errors) ? object : instance_variable_get("@#{object}")

      if obj && obj.errors[method].present?
        errors = safe_join(obj.errors[method], '<br />'.html_safe)
        content_tag(:span, errors, class: 'formError')
      else
        ''
      end
    end

    def datepicker_field_value(date)
      unless date.blank?
        l(date, format: t('date_picker.format', default: '%Y/%m/%d'))
      else
        nil
      end
    end

    def event_links(order, events)
      html = ""
      events.each do |event|
        if order.send("can_#{event}?")
          html += link_to  cancel_admin_order_path(order.id), class: 'btn btn-success', method: 'put' do
            raw "<i class='fa fa-#{event == 'cancel' ? 'times' : event}'></i> #{event.capitalize}"
          end
        end
      end
      html
    end

    # renders hidden field and link to remove record using nested_attributes
    def link_to_icon_remove_fields(f)
      url = f.object.persisted? ? [:admin, f.object] : '#'
      link_to_with_icon('delete', '', url, class: "spree_remove_fields btn btn-sm btn-danger", data: {action: 'remove'}, title: t(:remove)) + f.hidden_field(:_destroy)
    end

    def preference_fields(object, form)
      #p object.class::PREFERENCES
      #return unless object.class.respond_to?(:PREFERENCES)
      fields = object.class::PREFERENCES.map { |preference|
        if preference.present?
          form.label("preferred_#{preference[:field]}", t(preference[:field]) + ": ") +
              preference_field_for(form, "preferred_#{preference[:field]}", type: preference[:type])
        end
      }
      safe_join(fields, '<br />'.html_safe)
    end

    def preference_field_for(form, field, options)
      case options[:type]
        when :integer
          form.text_field(field, preference_field_options(options))
        when :boolean
          form.check_box(field, preference_field_options(options))
        when :string
          form.text_field(field, preference_field_options(options))
        when :password
          form.password_field(field, preference_field_options(options))
        when :text
          form.text_area(field, preference_field_options(options))
        else
          form.text_field(field, preference_field_options(options))
      end
    end

    def preference_field_options(options)
      field_options = case options[:type]
                        when :integer
                          {
                              size: 10,
                              class: 'input_integer form-control'
                          }
                        when :boolean
                          {}
                        when :string
                          {
                              size: 10,
                              class: 'input_string form-control'
                          }
                        when :password
                          {
                              size: 10,
                              class: 'password_string form-control'
                          }
                        when :text
                          {
                              rows: 15,
                              cols: 85,
                              class: 'form-control'
                          }
                        else
                          {
                              size: 10,
                              class: 'input_string form-control'
                          }
                      end

      field_options.merge!({
                               readonly: options[:readonly],
                               disabled: options[:disabled],
                               size: options[:size]
                           })
    end

    I18N_PLURAL_MANY_COUNT = 2.1

    def plural_resource_name(resource_class)
      resource_class.model_name.human(count: I18N_PLURAL_MANY_COUNT)
    end

    def order_time(time)
      time.strftime("%l:%M %p")
    end

    private
    def attribute_name_for(field_name)
      field_name.gsub(' ', '_').downcase
    end
  end
end