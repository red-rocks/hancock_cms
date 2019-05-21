#tabbed form navigator
# $(document).on 'click', '.fieldset-list .pjax', (e)->
#   $.pjax(url: e.currentTarget.dataset.url, container: '[data-pjax-container]')


# tabbed edit form changes detector
# $(document).on "change", "#hancock_tabbed_edit_form > form *, #hancock_tabbed_edit_form > form", (e)->
$(document).on "change", "#hancock_tabbed_edit_form > form", (e)->
  wrapper = $("#hancock_tabbed_edit_form")
  form = $("#hancock_tabbed_edit_form > form")
  if form.serialize() == form.data('old-val')
    wrapper.removeClass("form-data-changed")
  else
    wrapper.addClass("form-data-changed")
  calculateTopButtons(form)

$(document).on "rails_admin.dom_ready", (e)->
  form = $("#hancock_tabbed_edit_form > form")
  if form.length > 0
    form.each ->
      f = $(this)
      f.data('old-val', f.serialize())
      calculateTopButtons(f)


calculateTopButtons = (f)->
  btns = f.find('.form-actions.top-buttons')
  if f.height() < $(window).height()
    btns.hide()
  else
    btns.show()

      