class DateHtml5Input < SimpleForm::Inputs::StringInput
  def input_html_options
    value = object.send(attribute_name)
    options = {
      value: value,
      type: 'date'
    }
    super.merge options
  end
end
