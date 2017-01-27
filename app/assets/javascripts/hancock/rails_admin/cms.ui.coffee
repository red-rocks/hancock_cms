#= require_self

#= require ./navigation_dropdown
#= require ./navigation_scroll
#= require ./navigation_filter

#= require ./multiselect
#= require ./enum_with_custom

window.hancock_cms ||= {}





$(document).delegate "fieldset .leftside_hider", "click", (e)->
  e.preventDefault()
  fieldset = $(e.currentTarget).closest('fieldset')
  fieldset.find('legend').click()
  return false

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
  finish_position = fieldset.next().offset().top - $(window).height()
  return false if start_position > finish_position
  speed = 1.7 # px/msec
  duration = Math.abs((finish_position - start_position) / speed)
  $("html, body").animate({scrollTop: finish_position}, duration);
  return false


$(window).scroll (e)->
  window_center = window.scrollY + $(window).height()/2
  offset = 50
  $("fieldset .leftside_hider:visible").each ->
    me = $(this)
    min_position = me.offset().top + offset
    max_position = me.offset().top + me.height() - offset
    scroll_block = me.find(".scroll_fieldset_block")
    if window_center <= min_position
      scroll_block.css(top: offset, bottom: "")
    else
      if window_center >= max_position
        scroll_block.css(top: "", bottom: 0)
      else
        scroll_block.css(top: window_center - min_position + offset, bottom: "")






$(document).delegate "#form_controls_fixed a", "click", (e)->
  e.preventDefault()
  $(e.currentTarget).data('target').click()
  return false


$(document).bind 'rails_admin.dom_ready', ->
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
      clone_link = $("<a href='#' title='" + this.title + "'>" + $(this).text() + "</a>")
      clone_link.data('target', $(this))
      form_controls_fixed.append(clone_link)
