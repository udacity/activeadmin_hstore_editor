#-*- encoding: utf-8; tab-width: 2 -*-

class JsonInput < Formtastic::Inputs::TextInput
  def to_html
    html = '<div class="jsoneditor-wrap">'
    current_value = @object.public_send method
    html << builder.text_area(method, input_html_options.merge(
                                        value: value_to_json(current_value, method)))
    html << '</div>'
    html << '<div style="clear: both"></div>'
    input_wrapping do
      label_html << html.html_safe
    end
  end

  private

  def value_to_json(current_value, method)
    return '' if current_value.blank?
    return current_value if column_type_json?(method)
    current_value.try(:to_json).to_s
  end

  def column_type_json?(method)
    type = @object.column_for_attribute(method).type
    %i(jsonb json).include?(type)
  end
end
