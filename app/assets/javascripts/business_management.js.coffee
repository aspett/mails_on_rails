# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
<<<<<<< HEAD


$ ->
  if($('body#business_management_logs').length > 0)
    $('.table').dataTable(
      "bPaginate": true
      "bLengthChange": true
      "bFilter": true
      "bSort": true
      "bInfo": true
      "bAutoWidth": true
      "aaSorting": [[0, "desc"]]
    )
    
  if($('body#business_management_figures').length > 0)
    $('.data_table').dataTable(
      "bPaginate": true
      "bLengthChange": true
      "bFilter": true
      "bSort": true
      "bInfo": true
      "bAutoWidth": true
      "aaSorting": [[0, "desc"]]
    )
