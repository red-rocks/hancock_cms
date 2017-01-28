#= require ./en_ru_switcher

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
    return false

$(document).delegate '#navigation_filter', 'keyup', (e)->
  filter = e.currentTarget.value
  navigation_block = $(e.currentTarget).parent().siblings('.toolbar').find('.nav')
  nav_first_lvl = navigation_block.find("li.dropdown-header").removeClass('hidden').removeClass('opened').removeClass('opened-filtered')
  nav_sec_lvl = navigation_block.find("li[data-model]").removeClass('hidden').removeClass('visible')

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
