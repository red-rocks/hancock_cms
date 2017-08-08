#= require_self

$(document).on 'click', ".toggle-sidebar", (e)->
  e.preventDefault()
  $("#sidebar").toggleClass("shorted")
  return false
