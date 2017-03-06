#= require hancock/rails_admin/cms.ui
#= require hancock/rails_admin/custom/ui

$(window).load ->
  $('#preloader').fadeOut 'slow', ->
    $(this).remove()

$(document).bind "page:load", ->
  $('#preloader').fadeOut 'slow', ->
    $(this).remove()