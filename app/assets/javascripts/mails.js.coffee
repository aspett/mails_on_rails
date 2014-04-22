# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if($('body#mails_new').length > 0 || $('body#mails_create').length > 0)
    $('input.autocomplete-origin').autocomplete(
      source: $('div.autocomplete-origin').data('auto')
    )
    $('input.autocomplete-destination').autocomplete(
      source: $('div.autocomplete-origin').data('auto')
    )
  if($('body#mails_index').length > 0)
    $('.table').dataTable(
      "bPaginate": true
      "bLengthChange": false
      "bFilter": true
      "bSort": true
      "bInfo": true
      "bAutoWidth": true
      "aaSorting": [[4, "desc"], [0, "desc"]]
    )
    $('tr.route').on 'click', ->
      window.location.href = $(this).data('url')
