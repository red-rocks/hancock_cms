slide_to_top = () ->

  pos = $(window).scrollTop()

  if pos > 100
    $('.toplink').addClass('active')

  $(window).scroll ->
    if $(this).scrollTop() > 100
      $('.toplink').addClass('active')
    else
      $('.toplink').removeClass('active')

  $('.toplink').click ->
    $('html, body').stop().animate { scrollTop: 0 }, 500,'swing', ->
      $('.toplink').removeClass('active')
      return false
    return false

$(window).on 'load', ->
  slide_to_top()

$(document).bind "page:load", ->
  slide_to_top()