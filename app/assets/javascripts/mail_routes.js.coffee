# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



# IF YOU COPY ME, MAKE SURE YOU USE $ -> AT START OF THE FILE
$ ->
  if($('body#mail_routes_index').length > 0)
    dataTable = $('#table').dataTable(
      "bPaginate": true
      "bLengthChange": true
      "bFilter": true
      "bSort": true
      "bInfo": true
      "bAutoWidth": true
    )
    $('#table_2').dataTable(
      "bPaginate": true
      "bLengthChange": true
      "bFilter": true
      "bSort": true
      "bInfo": true
      "bAutoWidth": true
    )

    $('tfoot input').on 'keyup', ->
      dataTable.fnFilter(this.value, $("tfoot input").index(this))

    $('body').on 'click', 'tr.route', ->
      window.location.href = $(this).data('url')
    $('body').on 'mouseenter', 'tr.route', ->
      $(this).addClass('highlighted')
    $('body').on 'mouseleave', 'tr.route', ->
      $(this).removeClass('highlighted')

  if($('body#mail_routes_new').length > 0 || $('body#mail_routes_create').length > 0)
    $('input.autocomplete-origin').autocomplete(
      source: $('div.autocomplete-origin').data('auto')
    )
    $('input.autocomplete-destination').autocomplete(
      source: $('div.autocomplete-origin').data('auto')
    )
