#= require_self
#= require hancock/rails_admin/cms.ui
#= require hancock/rails_admin/custom/ui

$(window).load ->
  $('#preloader').fadeOut 'slow', ->
    $(this).remove()

$(document).on 'ready pjax:success', ->
  $('#preloader').fadeOut 'slow', ->
    $(this).remove()