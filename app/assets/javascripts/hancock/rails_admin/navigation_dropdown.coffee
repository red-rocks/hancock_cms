# $(document).delegate '.toolbar .nav .dropdown-header', 'click', (e)->
$(document).on 'click', '.toolbar .nav .dropdown-header', (e)->
  e.preventDefault()
  _target = $(e.currentTarget).toggleClass('opened')
  li = _target.next()
  loop
    li.toggleClass('visible')
    if _target.hasClass('forced-closed')
      li.addClass('forced-closed')
    else
      li.removeClass('forced-closed')
    if _target.hasClass('forced-opened')
      li.addClass('forced-opened')
    else
      li.removeClass('forced-opened')

    li = li.next()
    break if li.length == 0 or li.hasClass('dropdown-header')

    

$(document).on 'pjax:complete ready', ()->
  active_nav_element = $(".toolbar .nav .active")
  if active_nav_element.length > 0
    _parent = active_nav_element.prevAll(".dropdown-header:first")
    if _parent.length > 0 and !_parent.hasClass('opened')
      _parent.click()
