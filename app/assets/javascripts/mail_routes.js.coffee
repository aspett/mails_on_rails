# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



# IF YOU COPY ME, MAKE SURE YOU USE $ -> AT START OF THE FILE
$ ->
  if($('body#mail_routes_index').length > 0)
    $('.table').dataTable(
      "bPaginate": true
      "bLengthChange": true
      "bFilter": true
      "bSort": true
      "bInfo": true
      "bAutoWidth": true
    )
  if($('body#mail_routes_new').length > 0 || $('body#mail_routes_create').length > 0)
    $('input.autocomplete-origin').autocomplete(
      source: $('div.autocomplete-origin').data('auto')
    )
    $('input.autocomplete-destination').autocomplete(
      source: $('div.autocomplete-origin').data('auto')
    )

  if($('body#mail_routes_index').length > 0)
    $('body').on 'click', 'tr.route', ->
      window.location.href = $(this).data('url')


