#= require jquery.mCustomScrollbar.concat.min

window.hancock_cms ||= {}
window.hancock_cms.multiselect_dblclick = (selector)->
  $(document).delegate selector + ' .ra-multiselect-left select option', 'dblclick', (e)->
    $(e.currentTarget).closest('.ra-multiselect').find('.ra-multiselect-center .ra-multiselect-item-add').click()

  $(document).delegate selector + ' .ra-multiselect-right select option', 'dblclick', (e)->
    $(e.currentTarget).closest('.ra-multiselect').find('.ra-multiselect-center .ra-multiselect-item-remove').click()


$(document).delegate '.toolbar .nav .dropdown-header', 'click', (e)->
  e.preventDefault()
  _target = $(e.currentTarget).toggleClass('opened')
  li = _target.next()
  loop
    li.toggleClass('visible')
    li = li.next()
    break if li.length == 0 or li.hasClass('dropdown-header')

$(document).on 'pjax:complete ready', ()->
  active_nav_element = $(".toolbar .nav .active")
  if active_nav_element.length > 0
    _parent = active_nav_element.prevAll(".dropdown-header:first")
    if _parent.length > 0 and !_parent.hasClass('opened')
      _parent.click()

mscroll = () ->
  $('.toolbar').mCustomScrollbar(
    scrollInertia: 60
    mouseWheelPixels: 60
    theme: 'minimal'
    mouseWheel:
      scrollAmount: 0
  )

$(window).on 'load', ->
  mscroll()

$(document).bind "page:load", ->
  mscroll()
