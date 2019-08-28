# #= require ./en_ru_switcher

# $(document).on 'click', '.clear_navigation_filter_field', (e)->
#   e.preventDefault()
#   $("#navigation_filter").val("").trigger("keyup")
#   return false

# $(document).on 'keydown', '#sidebar, #sidebar *', (e)->
#   _code = e.which || e.keyCode
#   if _code == 13 or _code == 39 or _code == 37
#     _navig = $("#navigation_filter").parent().siblings('.toolbar').find('.nav')
#     return true if _navig.find("li:visible").length == 0 and _code != 13
#     if (_selected = _navig.find("li.current_selected")).length == 1
#       if !_selected.hasClass("dropdown-header") and (_link = _selected.find('a')).length > 0
#         if e.ctrlKey
#           window.open(_link[0].href, "_blank")
#         else
#           _link.click()
#       else
#         if _selected.hasClass('opened')
#           _selected.addClass('forced-closed').removeClass('forced-opened').click()
#         else
#           return true if _code == 37
#           _selected.removeClass('forced-closed').addClass('forced-opened').click()
#     else
#       return true if _code == 37
#       if (_selected = _navig.find('li.visible[data-model]')).length == 1
#         _link = _selected.find('a')
#         if e.ctrlKey
#           window.open(_link[0].href, "_blank")
#         else
#           _link.click()
#       else
#         return true if _code == 39


#     e.preventDefault()
#     return false
#   else
#     if _code == 38 or _code == 40
#       e.preventDefault()
#       if $('#navigation_filter').val().length == 0
#         _possible_sub_li_selector = "li.visible"
#         _possible_li_selector = "li.dropdown-header"
#       else
#         _possible_sub_li_selector = "li.visible"
#         _possible_li_selector = "li.opened, li.opened-filtered"
#       _navig = $(e.currentTarget).parent().siblings('.toolbar')
#       _visibled = _navig.find(".nav").find(_possible_li_selector + ", " + _possible_sub_li_selector)
#       _current = _visibled.filter(".current_selected")
#       _navig.find(".nav li").removeClass("current_selected")
#       if _code == 38 # up
#         if _current.length == 0
#           _current = _visibled.last()
#         else
#           if _current.hasClass("dropdown-header") # between block (prev or last)
#             prev_header = _current.prevAll(_possible_li_selector).first()
#             if prev_header.length == 0
#               prev_header = _visibled.last()
#             if prev_header.hasClass("opened")
#               _current = prev_header.find(_possible_sub_li_selector).last()
#             else
#               _current = prev_header
#           else # inside block
#             _current_sub = _current.prevAll(_possible_sub_li_selector).first()
#             if _current_sub.length == 0
#               _current = _current.closest(_possible_li_selector)
#             else
#               _current = _current_sub

#       else # down
#         if _current.length == 0
#           _current = _visibled.first()
#         else
#           if _current.hasClass("dropdown-header")
#             _current_sub = _current.find(_possible_sub_li_selector).first()
#           else
#             _current_sub = _current.nextAll(_possible_sub_li_selector).first()

#           if _current_sub.length > 0
#             _current = _current_sub
#           else
#             _current = _current.closest(_possible_li_selector).nextAll(_possible_li_selector).first()

#         if _current.length == 0
#           _current = _current.closest(_possible_li_selector).nextAll(_possible_li_selector).first()
#           if _current.length == 0
#             _current = _visibled.first()


#       _current.addClass("current_selected")
#       return false

#     else
#       $(e.currentTarget).parent().siblings('.toolbar').find(".nav li").removeClass('forced-closed').removeClass('forced-opened')
#       return true




# $(document).on 'keyup', '#sidebar, #sidebar *', (e)->
#   filter = $("#navigation_filter").val()
#   navigation_block = $("#navigation_filter").parent().siblings('.toolbar').find('.nav')
#   nav_first_lvl = navigation_block.find("li.dropdown-header:not(.forced-closed, .forced-opened)").removeClass('hidden').removeClass('opened').removeClass('opened-filtered')
#   nav_sec_lvl = navigation_block.find("li[data-model]:not(.forced-closed, .forced-opened)").removeClass('hidden').removeClass('visible')
#   select_menu_items = (filter, nav_first_lvl, nav_sec_lvl)->
#     if filter.length > 0
#       filter = new RegExp(filter, "i")

#       nav_first_lvl.each ->
#         me = $(this)
#         span = me.find("> span")
#         if !filter.test(span.html())
#           me.addClass("hidden")
#         else
#           me.addClass("opened").addClass("opened-filtered")

#       nav_sec_lvl.each ->
#         me = $(this)
#         return me.addClass("visible") if me.closest(".dropdown-header").hasClass('opened-filtered')
#         if !filter.test(me.find('a').text()) and !filter.test(me.data('model')) and !filter.test(me.data('name-synonyms') || "")
#           me.addClass("hidden")
#         else
#           me.addClass('visible').closest(".dropdown-header").removeClass('hidden').addClass('opened')

#   select_menu_items(filter, nav_first_lvl, nav_sec_lvl)
#   if navigation_block.find("li:visible").length == 0
#     nav_first_lvl.removeClass('hidden').removeClass('opened')
#     nav_sec_lvl.removeClass('hidden').removeClass('visible').filter(".active").closest(".dropdown-header").addClass("opened")
#     select_menu_items(window.hancock_cms.ru_en_change_string(filter), nav_first_lvl, nav_sec_lvl)

#   window.hancock_cms.navigation_mscroll()



# $(document).on "rails_admin.dom_ready", ->
#   _search_field = $('form #filters_box ~ .input-group [type="search"][name="query"]:not(:focus)')
#   _val = _search_field.val()
#   _search_field.focus().val("").val(_val)
