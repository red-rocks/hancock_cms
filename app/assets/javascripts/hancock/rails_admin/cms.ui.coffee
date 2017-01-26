#= require_self

#= require ./navigation_dropdown
#= require ./navigation_scroll
#= require ./navigation_filter

#= require ./multiselect
#= require ./enum_with_custom

window.hancock_cms ||= {}

$(document).bind 'rails_admin.dom_ready', ->
  $editors = $('[data-richtext=ckeditor]').not('.ckeditored')
  if $editors.length
    if not window.CKEDITOR
      options = $editors.first().data('options')
      window.CKEDITOR_BASEPATH = options['base_location']
      $.getScript options['jspath'], (script, textStatus, jqXHR) ->
        if window.CKEDITOR
          window.CKEDITOR.dtd.$removeEmpty[tag] = false for tag of window.CKEDITOR.dtd.$removeEmpty
