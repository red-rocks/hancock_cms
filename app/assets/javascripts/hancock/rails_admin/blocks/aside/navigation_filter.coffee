#= require hancock/rails_admin/en_ru_switcher

$(document).on 'click', '.clear-nav-filter', (e)->
  e.preventDefault()
  $("#nav-filter").val("").trigger("keyup")
  return false

$(document).on 'keydown', '#aside, #aside *', (e)->
  _code = e.which || e.keyCode
  if _code == 13 or _code == 39 or _code == 37
    # _navig = $("#nav-filter").parent().siblings('.aside-menu').find('.nav')
    _navig = $("#nav-filter").parent().siblings('.navigation-content').find('#aside-menu .nav:not(.root-navigation, .actions_navigation)')
    return true if _navig.find("li:visible").length == 0 and _code != 13
    if (_selected = _navig.find("li.current_selected")).length == 1
      if !_selected.hasClass("dropdown-header") and (_link = _selected.find('a')).length > 0
        if e.ctrlKey
          window.open(_link[0].href, "_blank")
        else
          _link.click()
      else
        if _selected.hasClass('opened')
          _selected.addClass('forced-closed').removeClass('forced-opened').click()
        else
          return true if _code == 37
          _selected.removeClass('forced-closed').addClass('forced-opened').click()
    else
      return true if _code == 37
      if (_selected = _navig.find('li.visible[data-model]')).length == 1
        _link = _selected.find('a')
        if e.ctrlKey
          window.open(_link[0].href, "_blank")
        else
          _link.click()
      else
        return true if _code == 39


    e.preventDefault()
    return false
  else
    if _code == 38 or _code == 40
      e.preventDefault()
      if $('#nav-filter').val().length == 0
        _possible_sub_li_selector = "li.visible"
        # _possible_li_selector = "li.dropdown-header[data-model]"
        _possible_li_selector = "li.dropdown-header"
      else
        _possible_sub_li_selector = "li.visible"
        _possible_li_selector = "li.opened, li.opened-filtered"
      # _navig = $(e.currentTarget).parent().siblings('.toolbar')
      _navig = $(e.currentTarget).parent().siblings('.navigation-content').find("#aside-menu")
      _visibled = _navig.find(".nav:not(.root-navigation, .actions_navigation)").find(_possible_li_selector + ", " + _possible_sub_li_selector)
      _current = _visibled.filter(".current_selected")
      all_items = _navig.find(".nav:not(.root-navigation, .actions_navigation) li").removeClass("current_selected")
      _current_index = all_items.index(_current)

      get_prev_visibled_from = (i, retry = true)->
        i ||= 0
        new_item = null
        while(i-- and !new_item)
          item = $(all_items[i])
          new_item = item if item.is(":visible")
        new_item = get_prev_visibled_from(all_items.length, false) if retry and !new_item
        $(new_item)

      get_next_visibled_from = (i, retry = true)->
        i ||= 0
        new_item = null
        while(i++ < all_items.length and !new_item)
          item = $(all_items[i])
          new_item = item if item.is(":visible")
        new_item = get_next_visibled_from(-1, false) if retry and !new_item
        $(new_item)
        
      
      _current = if _code == 38 # up
        if _current.length == 0 or _current_index == -1
          _visibled.last()
        else
          get_prev_visibled_from(_current_index || 0)

      else # down
        if _current.length == 0 or _current_index == -1
          _visibled.first()
        else
          get_next_visibled_from(_current_index || 0)

      _current.addClass("current_selected")
      return false

    else
      # $(e.currentTarget).parent().siblings('.aside-menu').find(".nav li").removeClass('forced-closed').removeClass('forced-opened')
      $(e.currentTarget).parent().siblings('.navigation-content').find("#aside-menu .nav li").removeClass('forced-closed').removeClass('forced-opened')
      return true


$(document).on 'keyup', '#aside, #aside *', (e)->
  filter = $("#nav-filter").val()
  # navigation_block = $(".navigation-filter").siblings('.aside-menu').find('.nav')
  navigation_block = $(".navigation-filter").siblings('.navigation-content').find('#aside-menu .nav:not(.root-navigation, .actions_navigation)')
  nav_first_lvl = navigation_block.find("li.dropdown-header:not(.forced-closed, .forced-opened)").removeClass('hidden').removeClass('opened').removeClass('opened-filtered')
  nav_sec_lvl = navigation_block.find("li[data-model]:not(.forced-closed, .forced-opened)").removeClass('hidden').removeClass('visible')
  select_menu_items = (filter, nav_first_lvl, nav_sec_lvl)->
    if filter.length > 0
      filter = new RegExp(filter, "i")

      nav_first_lvl.each ->
        me = $(this)
        span = me.find("> span")
        if !filter.test(span.html())
          me.addClass("hidden")
        else
          me.addClass("opened").addClass("opened-filtered")

      nav_sec_lvl.each ->
        me = $(this)
        return me.addClass("visible") if me.closest(".dropdown-header").hasClass('opened-filtered')
        if !filter.test(me.find('a').text()) and !filter.test(me.data('model')) and !filter.test(me.data('name-synonyms') || "")
          me.addClass("hidden")
        else
          me.addClass('visible').closest(".dropdown-header").removeClass('hidden').addClass('opened')

  select_menu_items(filter, nav_first_lvl, nav_sec_lvl)
  if navigation_block.find("li:visible").length == 0
    nav_first_lvl.removeClass('hidden').removeClass('opened')
    nav_sec_lvl.removeClass('hidden').removeClass('visible').filter(".active").closest(".dropdown-header").addClass("opened")
    select_menu_items(window.hancock.ru_en_change_string(filter), nav_first_lvl, nav_sec_lvl)



$(document).on "rails_admin.dom_ready", ->
  # _search_field = $('form #filters_box ~ .input-group [type="search"][name="query"]:not(:focus)')
  _search_field = $('#list form #filters_box ~ .well .input-group [type="search"][name="query"]:not(:focus)')
  _val = _search_field.val()
  _search_field.focus().val("").val(_val)


################# dropdown #################

$(document).on 'click', '#aside-menu .nav .dropdown-header li', (e)->
  e.stopPropagation()


$(document).on 'rails_admin.dom_ready', ->
  active_nav_element = $("#aside-menu .nav .active")
  if active_nav_element.length > 0
    _parent = active_nav_element.closest(".dropdown-header:first")
    if _parent.length > 0 and !_parent.hasClass('opened')
      _parent.click()