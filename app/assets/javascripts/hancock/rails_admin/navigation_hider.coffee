#= require_self

$(document).on 'click', ".toggle-sidebar", (e)->
  e.preventDefault()
  sidebar = $("#sidebar").toggleClass("shorted")
  $(e.currentTarget).find("i").toggleClass("fa-navicon").toggleClass("fa-angle-double-left")
  navigation_filter_input = $(".navigation-filter input")
  if sidebar.hasClass("shorted")
    navigation_filter_input.data("value", navigation_filter_input.val()).val("").closest(".navigation-filter").hide()
  else
    navigation_filter_input.val(navigation_filter_input.data("value")).closest(".navigation-filter").show()
  navigation_filter_input.trigger("keyup")
  return false
