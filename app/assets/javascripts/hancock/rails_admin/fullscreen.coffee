$(document).on 'click', '#fullscreen-toggler', (e) ->
  e.preventDefault()
  if checkFullscreen()
    cancelFullscreen()
    $('#fullscreen-toggler').removeClass('fullscreen')
  else
    launchFullScreen()
    $('#fullscreen-toggler').addClass('fullscreen')
  false