$ ->
  toggleBB = ->
    $('#tournament .bb').on 'click', (e)->
      e.preventDefault()
      $('#tournament #tournament-bb').foundation('reveal', 'open')
    $('#tournament #tournament-bb').on 'click', '.bb-copy', (e)->
      e.preventDefault()
      $bb = $('#tournament-bb textarea')
      window.prompt($bb.data('prompt'), $bb.val())

  $(document).ready toggleBB
  $(document).on 'page:load', toggleBB
