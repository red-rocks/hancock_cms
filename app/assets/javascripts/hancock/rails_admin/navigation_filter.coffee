#= require ./en_ru_switcher

# $(document).delegate '.clear_navigation_filter_field', 'click', (e)->
$(document).on 'click', '.clear_navigation_filter_field', (e)->
  e.preventDefault()
  $("#navigation_filter").val("").trigger("keyup")
  return false



# $(document).delegate '#navigation_filter', 'keypress', (e)->
$(document).on 'keydown', '#navigation_filter', (e)->
  _code = e.which || e.keyCode
  if _code == 13 or _code == 39 or _code == 37
    _navig = $(e.currentTarget).parent().siblings('.toolbar').find('.nav')
    return true if _navig.find("li:visible").length == 0 and _code != 13
    if (_selected = _navig.find("li.current_selected")).length == 1
      if _selected.find("a").length > 0
        _selected.find('a').click()
      else
        if _selected.hasClass('opened')
          _selected.addClass('forced-closed').removeClass('forced-opened').click()
        else
          return true if _code == 37
          _selected.removeClass('forced-closed').addClass('forced-opened').click()
    else
      return true if _code == 37
      if (_selected = _navig.find('li.visible[data-model]')).length == 1
        _selected.find('a').click()
      else
        return true if _code == 39


    e.preventDefault()
    return false
  else
    if _code == 38 or _code == 40
      e.preventDefault()
      if $('#navigation_filter').val().length == 0
        _possible_li_selector = "li.dropdown-header, li.visible"
      else
        _possible_li_selector = "li.opened, li.opened-filtered, li.visible"
      _navig = $(e.currentTarget).parent().siblings('.toolbar')
      _visibled = _navig.find(".nav").find(_possible_li_selector)
      _current = _visibled.filter(".current_selected")
      _navig.find(".nav li").removeClass("current_selected")
      if _code == 38 # up
        if _current.length == 0
          _current = _visibled.last()
        else
          _current = _current.prevAll(_possible_li_selector).first()
          _current = _visibled.last() if _current.length == 0
      else
        if _current.length == 0
          _current = _visibled.first()
        else
          _current = _current.nextAll(_possible_li_selector).first()
          _current = _visibled.first() if _current.length == 0
      _current.addClass("current_selected")
      return false

    else
      $(e.currentTarget).parent().siblings('.toolbar').find(".nav li").removeClass('forced-closed').removeClass('forced-opened')
      return true






# $(document).delegate '#navigation_filter', 'keyup', (e)->
$(document).on 'keyup', '#navigation_filter', (e)->
  filter = e.currentTarget.value
  navigation_block = $(e.currentTarget).parent().siblings('.toolbar').find('.nav')
  nav_first_lvl = navigation_block.find("li.dropdown-header:not(.forced-closed, .forced-opened)").removeClass('hidden').removeClass('opened').removeClass('opened-filtered')
  nav_sec_lvl = navigation_block.find("li[data-model]:not(.forced-closed, .forced-opened)").removeClass('hidden').removeClass('visible')

  select_menu_items = (filter, nav_first_lvl, nav_sec_lvl)->
    if filter.length > 0
      filter = new RegExp(filter, "i")

      nav_first_lvl.each ->
        me = $(this)
        if !filter.test(me.html())
          me.addClass("hidden")
        else
          me.addClass("opened").addClass("opened-filtered")

      nav_sec_lvl.each ->
        me = $(this)
        return me.addClass("visible") if me.prevAll(".dropdown-header").first().hasClass('opened-filtered')
        if !filter.test(me.find('a').text()) and !filter.test(me.data('model')) and !filter.test(me.data('name-synonyms') || "")
          me.addClass("hidden")
        else
          me.addClass('visible').prevAll(".dropdown-header").first().removeClass('hidden').addClass('opened')

  select_menu_items(filter, nav_first_lvl, nav_sec_lvl)
  if navigation_block.find("li:visible").length == 0
    nav_first_lvl.removeClass('hidden').removeClass('opened')
    nav_sec_lvl.removeClass('hidden').removeClass('visible')
    select_menu_items(window.hancock_cms.ru_en_change_string(filter), nav_first_lvl, nav_sec_lvl)

  window.hancock_cms.navigation_mscroll()
