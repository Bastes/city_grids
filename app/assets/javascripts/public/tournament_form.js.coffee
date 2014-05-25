$ ->
  dateSynchronizer = ->
    $('form.new_tournament, form.edit_tournament').each ->
      $form = $(this)
      $beginsAtDate = $('input[name="tournament[begins_at_date]"]')
      $endsAtDate   = $('input[name="tournament[ends_at_date]"]')
      $beginsAtTime = $('input[name="tournament[begins_at_time]"]')
      $endsAtTime   = $('input[name="tournament[ends_at_time]"]')
      previousBeginsAtDate = new Date($beginsAtDate.val())
      $form.on 'change', 'input[name="tournament[begins_at_date]"]', ->
        newBeginsAtDate = new Date($beginsAtDate.val())
        return if previousBeginsAtDate == newBeginsAtDate
        if $endsAtDate.val() == ''
          $($endsAtDate.val(newBeginsAtDate.toJSON().match(/\d+-\d+-\d+/)))
        else
          dateOffset = ((new Date($endsAtDate.val())) - previousBeginsAtDate) / (24 * 60 * 60 * 1000)
          newEndsAtDate = new Date(newBeginsAtDate.getTime() + dateOffset * 24 * 60 * 60 * 1000)
          $($endsAtDate.val(newEndsAtDate.toJSON().match(/\d+-\d+-\d+/)))
        previousBeginsAtDate = newBeginsAtDate

  $(document).ready dateSynchronizer
  $(document).on 'page:load', dateSynchronizer
