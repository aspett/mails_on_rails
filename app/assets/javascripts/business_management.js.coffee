# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
$ ->
  if($('body#business_management_figures').length > 0)
    $('.data_table').dataTable(
      "bPaginate": true
      "bLengthChange": true
      "bFilter": true
      "bSort": true
      "bInfo": true
      "bAutoWidth": true
    )
