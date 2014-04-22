# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  if($('body#users_index').length > 0)
    $('.table').dataTable(
      "bPaginate": false
      "bLengthChange": false
      "bFilter": true
      "bSort": true
      "bInfo": false
      "bAutoWidth": false
    )
