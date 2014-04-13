module MessagePart
  MATCHERS = {
    plain: %r{\Atext/plain; charset=UTF-8\Z},
    html:  %r{\Atext/html; charset=UTF-8\Z}
  }

  def message_part mail, content_type
    content_type = content_type.to_sym
    mail.body.parts.find { |part| part.content_type =~ MATCHERS[content_type] }.body
  end
end
