# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.table').dataTable(
    "bPaginate": false
    "bLengthChange": false
    "bFilter": true
    "bSort": true
    "bInfo": false
    "bAutoWidth": false
  )
  if($('body#mail_routes_new').length > 0 || $('body#mail_routes_create').length > 0)
    $('input.autocomplete-origin').autocomplete(
      source: $('div.autocomplete-origin').data('auto')
    )
    $('input.autocomplete-destination').autocomplete(
      source: $('div.autocomplete-origin').data('auto')
    )

  if($('body#mail_routes_index').length > 0)
    $('tr.route').on 'click', ->
      window.location.href = $(this).data('url')


