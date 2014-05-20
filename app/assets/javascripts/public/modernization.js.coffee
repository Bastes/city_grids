$ ->
  (->
    return if Modernizr.inputtypes.date
    inputDateFallback = ->
      $('input[type="date"]').datepicker dateFormat: 'yy-mm-dd'

    $(document).ready inputDateFallback
    $(document).on 'page:load', inputDateFallback
  )()

  (->
    return if Modernizr.inputtypes.time
    inputTimeFallback = ->
      $('input[type="time"]').removeAttr('pattern')

    $(document).ready inputTimeFallback
    $(document).on 'page:load', inputTimeFallback
  )()
