class TimeHtml5Input < SimpleForm::Inputs::StringInput
  def input_html_options
    value = object.send(attribute_name)
    options = {
      value: value,
      type: 'time'
    }
    super.merge options
  end
end
