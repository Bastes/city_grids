$ ->
  return if Modernizr.inputtypes.date
  inputDateFallback = ->
    $('input[type="date"]').datepicker dateFormat: 'yy-mm-dd'

  $(document).ready inputDateFallback
  $(document).on 'page:load', inputDateFallback
