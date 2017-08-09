#= require_self

$(document).on 'click', ".toggle-sidebar", (e)->
  e.preventDefault()
  sidebar = $("#sidebar").toggleClass("shorted")
  navigation_filter_input = $(".navigation-filter input")
  if sidebar.hasClass("shorted")
    navigation_filter_input.data("value", navigation_filter_input.val()).val("").prop( "disabled", true )
  else
    navigation_filter_input.val(navigation_filter_input.data("value")).prop( "disabled", false )
  navigation_filter_input.trigger("keyup")
  return false
