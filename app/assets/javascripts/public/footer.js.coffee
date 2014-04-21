$ ->
  positionFooter = ->
    $footer = $("footer:last")
    marginTop = $(window).height() - $footer.position().top - $footer.outerHeight()
    if (marginTop > 0)
      $footer.css 'margin-top': "#{marginTop}px"

  $(document).ready positionFooter
  $(document).on 'page:load', positionFooter
