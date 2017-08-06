#= require jquery.mCustomScrollbar.concat.min

#= require_self

window.hancock_cms.navigation_mscroll = () ->
  $('.custom_scroll').mCustomScrollbar(
    scrollInertia: 60
    mouseWheelPixels: 60
    theme: 'minimal'
    mouseWheel:
      scrollAmount: 0
  )

$(document).on 'rails_admin.dom_ready', ->
  window.hancock_cms.navigation_mscroll()

$(window).on 'resize', ->
  $('.custom_scroll').mCustomScrollbar("update")