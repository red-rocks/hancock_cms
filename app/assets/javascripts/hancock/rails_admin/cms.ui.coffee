#= require_self

#= require ./navigation_dropdown
#= require ./navigation_scroll
#= require ./navigation_filter

#= require ./multiselect
#= require ./enum_with_custom

window.hancock_cms ||= {}

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
