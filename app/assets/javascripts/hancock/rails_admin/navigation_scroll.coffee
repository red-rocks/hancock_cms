#= require jquery.mCustomScrollbar.concat.min

mscroll = () ->
  $('.toolbar').mCustomScrollbar(
    scrollInertia: 60
    mouseWheelPixels: 60
    theme: 'minimal'
    mouseWheel:
      scrollAmount: 0
  )
$(window).bind 'load', ->
  mscroll()
$(document).bind "page:load", ->
  mscroll()
