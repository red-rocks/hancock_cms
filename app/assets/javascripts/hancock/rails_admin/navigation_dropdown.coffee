$(document).on 'click', '.toolbar .nav .dropdown-header', (e)->
  e.preventDefault()

  if $("#sidebar.shorted").length > 0
    $('.toggle-sidebar').trigger("click")
    $('.clear_navigation_filter_field').trigger("click")

  _target = $(e.currentTarget).toggleClass('opened')
  li = _target.find("li").toggleClass('visible')
  if _target.hasClass('forced-closed')
    li.addClass('forced-closed')
  else
    li.removeClass('forced-closed')
  if _target.hasClass('forced-opened')
    li.addClass('forced-opened')
  else
    li.removeClass('forced-opened')

$(document).on 'click', '.toolbar .nav .dropdown-header li', (e)->
  e.stopPropagation()

$(document).on 'rails_admin.dom_ready', ->
  active_nav_element = $(".toolbar .nav .active")
  if active_nav_element.length > 0
    _parent = active_nav_element.closest(".dropdown-header:first")
    if _parent.length > 0 and !_parent.hasClass('opened')
      _parent.click()


