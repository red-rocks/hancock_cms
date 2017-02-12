$(document).on "rails_admin.dom_ready", ->
  _offsettop = $(window).height() / 2 - 63
  $('.scroll_fieldset_block').each ->
    me = $(this)
    me.stick_in_parent(
      offset_top: _offsettop
    )

$(document).on "mouseenter", "fieldset", (e)->
  $(e.currentTarget).addClass("hover")

$(document).on "mouseleave", "fieldset", (e)->
  $(e.currentTarget).removeClass("hover")


$(document).on "click", "fieldset .leftside_hider", (e)->
  e.preventDefault()
  fieldset = $(e.currentTarget).closest('fieldset')
  fieldset.find('legend').click()
  return false

#
# $(document).on "mouseenter", "fieldset .leftside_hider", (e)->
#   $(window).scroll()


# $(window).scroll (e)->
#  window_center = window.scrollY + $(window).height()/2
#  offset = 50
#  $("fieldset .leftside_hider:visible").each ->
#    me = $(this)
#    min_position = me.offset().top + offset
#    max_position = me.offset().top + me.height() - offset
#    scroll_block = me.find(".scroll_fieldset_block")
#    if window_center <= min_position
#      scroll_block.css(top: offset, bottom: "")
#    else
#      if window_center >= max_position
#        scroll_block.css(top: "", bottom: 0)
#      else
#        scroll_block.css(top: window_center - min_position + offset, bottom: "")


$(document).on "click", "fieldset .leftside_hider .scroll_fieldset_top", (e)->
  e.preventDefault()
  fieldset = $(e.currentTarget).closest('fieldset')
  start_position = window.scrollY
  finish_position = fieldset.offset().top - 60
  return false if start_position < finish_position
  speed = 1.7 # px/msec
  duration = Math.abs((finish_position - start_position) / speed)
  $("html, body").animate({scrollTop: finish_position}, duration);
  return false


$(document).on "click", "fieldset .leftside_hider .scroll_fieldset_bottom", (e)->
  e.preventDefault()
  fieldset = $(e.currentTarget).closest('fieldset')
  start_position = window.scrollY
  finish_position = fieldset.next().offset().top - $(window).height() + 35   # 35px - offset-bottom
  return false if start_position > finish_position
  speed = 1.7 # px/msec
  duration = Math.abs((finish_position - start_position) / speed)
  $("html, body").animate({scrollTop: finish_position}, duration);
  return false


$(document).on "click", "fieldset .leftside_hider .select_fieldset", (e)->
  e.preventDefault()
  me = $(e.currentTarget)
  fieldset = me.closest('fieldset')
  fieldsets = fieldset.siblings('fieldset').andSelf()
  fieldset_links = []
  fieldsets.each ->
    f = $(this)
    l = $(this).find("legend:first")
    if f[0] == fieldset[0]
      fieldset_link = $("<span></span>").attr("title", l.text()).text(l.text())
    else
      fieldset_link = $("<a></a>").attr("title", l.text()).attr("href", '#').text(l.text()).data('target', f)

    fieldset_links.push(fieldset_link)
  me.html("").append(fieldset_links).addClass('links-list')
  #  css(width: "auto", display: 'inline-flex')
  #  me.html("").append(fieldset_links).css(width: fieldset_links.length * 60 + "px")
  return false


$(document).delegate ".scroll_fieldset_block", "mouseleave", (e)->
  me = $(e.currentTarget).find('.select_fieldset')
  me.html("<i class='fa fa-indent'></i>").removeClass('links-list')
  return false

$(document).on "click", ".form-horizontal legend", (e)->
  fieldset = $(this).closest("fieldset")
  if $(this).has('i.icon-chevron-down').length
    fieldset.addClass('opened')
    fieldset.find('.scroll_fieldset_block').css(position: '', top: '').trigger("sticky_kit:recalc")
  else
    if $(this).has('i.icon-chevron-right').length
      fieldset.removeClass('opened')


$(document).on "click", "fieldset .leftside_hider .select_fieldset a", (e)->
  e.preventDefault()
  e.stopImmediatePropagation()
  hide_previous = true
  me = $(e.currentTarget)
  fieldset = $(me.closest('fieldset'))
  fieldsets = fieldset.siblings('fieldset').andSelf()
  target = $(me.data('target'))
  me.closest('select_fieldset').html("SF").css(width: "")
  target_position = $(fieldsets[0]).offset().top
  for i in [0..fieldsets.length]
    fs = $(fieldsets[i])
    if fs[0] == target[0]
      break
    if hide_previous and fieldset[0] == fs[0]
      target_position += 30
    else
      target_position += fs.height()
  target_position -= 60

  fieldset.find("legend:visible").click() if fieldset.hasClass('opened') if hide_previous
  target.find("legend:visible").click() unless target.hasClass('opened')
  $("html, body").animate({scrollTop: target_position}, 300);
  return false
