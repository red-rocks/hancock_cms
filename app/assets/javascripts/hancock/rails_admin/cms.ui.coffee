window.hancock_cms ||= {}
window.hancock_cms.multiselect_dblclick = (selector)->
  $(document).delegate selector + ' .ra-multiselect-left select option', 'dblclick', (e)->
    $(e.currentTarget).closest('.ra-multiselect').find('.ra-multiselect-center .ra-multiselect-item-add').click()

  $(document).delegate selector + ' .ra-multiselect-right select option', 'dblclick', (e)->
    $(e.currentTarget).closest('.ra-multiselect').find('.ra-multiselect-center .ra-multiselect-item-remove').click()




$(document).delegate '.sidebar-nav .nav .dropdown-header', 'click', (e)->
  e.preventDefault()
  _target = $(e.currentTarget).toggleClass('opened')
  li = _target.next()
  loop
    li.toggleClass('visible')
    li = li.next()
    break if li.length == 0 or li.hasClass('dropdown-header')

$(document).on 'pjax:complete ready', ()->
  active_nav_element = $(".sidebar-nav .nav .active")
  if active_nav_element.length > 0
    _parent = active_nav_element.prevAll(".dropdown-header:first")
    if _parent.length > 0 and !_parent.hasClass('opened')
      _parent.click()



# ripple-effect before click on buttons
ripple_selector = "ul.nav-pills li, .root_links li, .top-nav-project"
$(document).delegate ripple_selector, "click", (event)->
  # event.preventDefault()
  $div = $('<div/>')
  btnOffset = $(this).offset()
  xPos = event.pageX - (btnOffset.left)
  yPos = event.pageY - (btnOffset.top)
  $div.addClass 'ripple-effect'
  $ripple = $('.ripple-effect')
  $ripple.css 'height', $(this).height()
  $ripple.css 'width', $(this).height()
  $div.css(
    top: yPos - ($ripple.height() / 2)
    left: xPos - ($ripple.width() / 2)
    background: $(this).data('ripple-color')).appendTo $(this)
  window.setTimeout (->
    $div.remove()
    return
  ), 1000
  return
