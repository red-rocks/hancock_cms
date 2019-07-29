window.launchFullScreen = ->
  element = $('body')[0]
  if element.requestFullScreen
    element.requestFullScreen()
  else if element.mozRequestFullScreen
    element.mozRequestFullScreen()
  else if element.webkitRequestFullScreen
    element.webkitRequestFullScreen()

window.cancelFullscreen = ->
  if document.cancelFullScreen
    document.cancelFullScreen()
  else if document.mozCancelFullScreen
    document.mozCancelFullScreen()
  else if document.webkitCancelFullScreen
    document.webkitCancelFullScreen()

window.checkFullscreen = ->
  if document.fullscreenElement or document.mozFullscreenElement or document.webkitFullscreenElement
    return true
  false

$(document).on 'click', '#fullscreen-toggler', (e) ->
  e.preventDefault()
  if checkFullscreen()
    cancelFullscreen()
    $('#fullscreen-toggler').removeClass('fullscreen')
  else
    launchFullScreen()
    $('#fullscreen-toggler').addClass('fullscreen')
  false