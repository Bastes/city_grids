class TimeHtml5Input < SimpleForm::Inputs::StringInput
  enable :placeholder

  def input_html_options
    super.merge options.merge({
      value: object.send(attribute_name),
      type: 'time'
    })
  end
end
