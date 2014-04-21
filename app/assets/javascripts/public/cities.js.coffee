$ ->
  visitCities = ->
    $('#cities ul.cities').on 'click', 'li .city', (e)->
      return if $(e.target).is('a')
      Turbolinks.visit($(this).find('h2 a:first').attr('href'))

  $(document).ready visitCities
  $(document).on 'page:load', visitCities
