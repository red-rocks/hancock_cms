#= require jquery.mCustomScrollbar.concat.min

#= require ./en_ru_switcher



window.hancock_cms ||= {}
window.hancock_cms.multiselect_dblclick = (selector)->
  $(document).delegate selector + ' .ra-multiselect-left select option', 'dblclick', (e)->
    $(e.currentTarget).closest('.ra-multiselect').find('.ra-multiselect-center .ra-multiselect-item-add').click()

  $(document).delegate selector + ' .ra-multiselect-right select option', 'dblclick', (e)->
    $(e.currentTarget).closest('.ra-multiselect').find('.ra-multiselect-center .ra-multiselect-item-remove').click()

window.hancock_cms.multiselect_dblclick("select.hancock_multiselect + .ra-multiselect, select.hancock_enum + .ra-multiselect")


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
$(window).bind 'load', ->
  mscroll()
$(document).bind "page:load", ->
  mscroll()




$(document).delegate '.clear_navigation_filter_field', 'click', (e)->
  e.preventDefault()
  $("#navigation_filter").val("").trigger("keyup")
  return false

$(document).delegate '#navigation_filter', 'keypress', (e)->
  _code = e.which || e.keyCode
  if _code == 13
    e.preventDefault()
    if (_selected = $(e.currentTarget).siblings('.toolbar').find('.nav li.visible[data-model]')).length == 1
      _selected.find('a').click()
    return fasle

$(document).delegate '#navigation_filter', 'keyup', (e)->
  filter = e.currentTarget.value
  navigation_block = $(e.currentTarget).siblings('.toolbar').find('.nav')
  nav_first_lvl = navigation_block.find("li.dropdown-header").removeClass('hidden').removeClass('opened')
  nav_sec_lvl = navigation_block.find("li[data-model]").removeClass('hidden').removeClass('visible')

  select_menu_items = (filter, nav_first_lvl, nav_sec_lvl)->
    if filter.length > 0
      filter = new RegExp(filter, "i")

      nav_first_lvl.each ->
        me = $(this)
        if !filter.test(me.innerHTML)
          me.addClass("hidden")

      nav_sec_lvl.each ->
        me = $(this)
        if !filter.test(me.find('a').text()) and !filter.test(me.data('model')) and !filter.test(me.data('name-synonyms') || "")
          me.addClass("hidden")
        else
          me.addClass('visible').prevAll(".dropdown-header").first().removeClass('hidden').addClass('opened')

  select_menu_items(filter, nav_first_lvl, nav_sec_lvl)
  if navigation_block.find("li:visible").length == 0
    nav_first_lvl.removeClass('hidden').removeClass('opened')
    nav_sec_lvl.removeClass('hidden').removeClass('visible')
    select_menu_items(window.hancock_cms.ru_en_change_string(filter), nav_first_lvl, nav_sec_lvl)
