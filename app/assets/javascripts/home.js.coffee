$ ->
  current_page = $('body').data('controller')
  $("#main_nav > li[id='#{current_page}']").addClass('active')
