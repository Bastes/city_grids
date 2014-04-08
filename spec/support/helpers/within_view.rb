# gives the "within" method to view specs for less repetition
module WithinView
  def within selectorOrFragment, selector = nil
    fragment = if selector then selectorOrFragment else Capybara.string(rendered) end
    yield fragment.find(selector || selectorOrFragment)
  end
end
