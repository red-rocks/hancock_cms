
$(document).on "click", "#form_controls_fixed a", (e)->
  e.preventDefault()
  $(e.currentTarget).data('target').click()
  return false


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

## load CKEDITOR env for user ckeditor assets loading anythere
# $(document).on 'rails_admin.dom_ready', ->
#   return if $("#form_controls_fixed").length > 0
#   $editors = $('[data-richtext=ckeditor]').not('.ckeditored')
#   if $editors.length
#     if not window.CKEDITOR
#       options = $editors.first().data('options')
#       window.CKEDITOR_BASEPATH = options['base_location']
#       $.getScript options['jspath'], (script, textStatus, jqXHR) ->
#         if window.CKEDITOR
#           window.CKEDITOR.dtd.$removeEmpty[tag] = false for tag of window.CKEDITOR.dtd.$removeEmpty
