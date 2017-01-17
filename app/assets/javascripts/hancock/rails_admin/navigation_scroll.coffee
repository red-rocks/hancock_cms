#= require jquery.mCustomScrollbar.concat.min

window.hancock_cms.navigation_mscroll = () ->
  $('.toolbar').mCustomScrollbar(
    scrollInertia: 60
    mouseWheelPixels: 60
    theme: 'minimal'
    mouseWheel:
      scrollAmount: 0
  )
$(window).bind 'load', ->
  window.hancock_cms.navigation_mscroll()
$(document).bind "page:load", ->
  window.hancock_cms.navigation_mscroll()
