#= require_self

#= require jquery.sticky-kit.js

#= require ./navigation_dropdown
#= require ./navigation_scroll
#= require ./navigation_filter

#= require ./multiselect
#= require ./enum_with_custom

window.hancock_cms ||= {}

$(window).bind 'load', ->
  $('.leftside_hider').stick_in_parent(
    offset_top: 60
  )

$(document).bind "page:load", ->
  $('.leftside_hider').stick_in_parent(
    offset_top: 60
  )

#$(document).delegate "fieldset .leftside_hider", "click", (e)->
#  e.preventDefault()
#  fieldset = $(e.currentTarget).closest('fieldset')
#  fieldset.find('legend').click()
#  return false

#$(document).delegate "fieldset .leftside_hider", "mouseenter", (e)->
#  $(window).scroll()

$(document).delegate "fieldset .leftside_hider .scroll_fieldset_top", "click", (e)->
  e.preventDefault()
  fieldset = $(e.currentTarget).closest('fieldset')
  start_position = window.scrollY
  finish_position = fieldset.offset().top - 60
  return false if start_position < finish_position
  speed = 1.7 # px/msec
  duration = Math.abs((finish_position - start_position) / speed)
  $("html, body").animate({scrollTop: finish_position}, duration);
  return false

$(document).delegate "fieldset .leftside_hider .scroll_fieldset_bottom", "click", (e)->
  e.preventDefault()
  fieldset = $(e.currentTarget).closest('fieldset')
  start_position = window.scrollY
  finish_position = fieldset.next().offset().top - $(window).height() + 35   # 35px - offset-bottom
  return false if start_position > finish_position
  speed = 1.7 # px/msec
  duration = Math.abs((finish_position - start_position) / speed)
  $("html, body").animate({scrollTop: finish_position}, duration);
  return false

$(document).delegate "fieldset .leftside_hider .select_fieldset", "click", (e)->
  e.preventDefault()
  me = $(e.currentTarget)
  fieldset = me.closest('fieldset')
  fieldsets = fieldset.siblings('fieldset')
  fieldset_links = []
  fieldsets.each ->
    f = $(this)
    l = $(this).find("legend:first")
    fieldset_link = $("<a title='" + l.text() + "' href='#'>" + l.text() + "</a>")
    fieldset_link.data('target', f)
    fieldset_links.push(fieldset_link)
  me.html("").append(fieldset_links).addClass('links-list')
#  css(width: "auto", display: 'inline-flex')
#  me.html("").append(fieldset_links).css(width: fieldset_links.length * 60 + "px")
  return false

$(document).delegate ".select_fieldset", "mouseleave", (e)->
  me = $(e.currentTarget)
  me.html("<i class='fa fa-indent'></i>").removeClass('links-list')
  return false

$(document).delegate ".form-horizontal legend", "click", (e)->
  fieldset = $(this).closest("fieldset")

  if $(this).has('i.icon-chevron-down').length
    fieldset.addClass('opened')
    fieldset.find('.leftside_hider').css(position: '', top: '')
  else
    if $(this).has('i.icon-chevron-right').length
      fieldset.removeClass('opened')

$(document).delegate "fieldset .leftside_hider .select_fieldset a", "click", (e)->
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

#$(window).scroll (e)->
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

$(document).delegate "#form_controls_fixed a", "click", (e)->
  e.preventDefault()
  $(e.currentTarget).data('target').click()
  return false

$(document).bind 'rails_admin.dom_ready', ->
  return if $("#form_controls_fixed").length > 0
  $editors = $('[data-richtext=ckeditor]').not('.ckeditored')
  if $editors.length
    if not window.CKEDITOR
      options = $editors.first().data('options')
      window.CKEDITOR_BASEPATH = options['base_location']
      $.getScript options['jspath'], (script, textStatus, jqXHR) ->
        if window.CKEDITOR
          window.CKEDITOR.dtd.$removeEmpty[tag] = false for tag of window.CKEDITOR.dtd.$removeEmpty

  $('form .form-actions').each ->
    me = $(this)
    form = me.closest("form")
    buttons = me.find("button")
    form.append("<div id='form_controls_fixed'></div>")
    form_controls_fixed = form.find("#form_controls_fixed")
    buttons.each ->
      clone_link = $("<a href='#' class='clone" + $(this).attr( 'name' ) + "' title='" + $(this).text() + "'></a>")
      clone_link.data('target', $(this))
      form_controls_fixed.append(clone_link)
