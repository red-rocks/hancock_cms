$(document).on "click", ".hancock_hash_type .hash_element_renamer_link", (ev)->
  ev.preventDefault()
  renamer_link = $(ev.currentTarget)
  label = renamer_link.closest('.hash_element_block').find('label')
  input = renamer_link.closest('.hash_element_block').find('input')
  new_renamer_link = renamer_link.clone()
  renamer_field = $("<input>").addClass('hash_element_renamer_field').prop("type", "string").prop("placeholder", "Новое имя").prop("value", label.text())
  renamer_link.replaceWith(renamer_field)
  label.hide()
  input.hide()
  renamer_field.focus().blur( ->
    renamer_field.replaceWith(renamer_link)
    label.show()
    input.show()
  ).keypress((e)->
    key = e.which || e.keyCode
    if key == 13
      e.preventDefault()
      new_name = renamer_field.val().trim()
      if new_name.length > 0
        old_id    = input.prop('id')
        old_name  = input.prop('name')
        reg_for_id = /\[[^\[\]]+\]$/i
        reg_for_name = /\[[^\[\]]+\]\]$/i
        label.prop('for',   old_id.replace(reg_for_id, "[" + new_name + "]")).text(new_name)
        input.prop('id',    old_id.replace(reg_for_id, "[" + new_name + "]"))
        input.prop('name',  old_name.replace(reg_for_name, "[" + new_name + "]]"))
      renamer_field.blur()
      input.focus()
      return false
  ).keydown((e)->
    key = e.which || e.keyCode
    if key == 27
      renamer_field.blur()
      return false
  ).select()
  return false



$(document).on "click", ".hancock_hash_type .hash_element_add_link", (e)->
  e.preventDefault()
  link = $(e.currentTarget)
  link_parent = link.parent()
  link_parent.before(link.data('template'))
  # link_parent.prev().find('input:first').focus().select()
  link_parent.prev().find('.hash_element_renamer_link').click()
  return false


$(document).on 'click', '.hancock_hash_type .hash_element_delete_link', (e)->
  e.preventDefault()
  $(e.currentTarget).parent().remove()
  return false

$(document).on 'blur', '.hancock_hash_type .hash_element_key_field', (e)->
  e.preventDefault()
  input = $(e.currentTarget).siblings('input')
  old_id    = input.prop('id')
  old_name  = input.prop('name')
  new_name = e.currentTarget.value
  reg_for_id = /\[[^\[\]]+\]$/i
  reg_for_name = /\[[^\[\]]+\]\]$/i
  input.prop('id',    old_id.replace(reg_for_id, "[" + new_name + "]"))
  input.prop('name',  old_name.replace(reg_for_name, "[" + new_name + "]]"))
  return false


$(document).on 'blur', '.hancock_hash_type .hash_element_block input', (e)->
  fields_block = $(e.currentTarget).closest(".controls")
  fields_block.find('.value_field').each ->
    $(this).parent().removeClass('duplicate')
    fields_block.find('.value_field').not($(this)).filter("[name='" + this.name + "']").parent().addClass('duplicate')




  # $(document).on 'click', '.hash_element_duplicate_trigger', (e)->
  #   e.preventDefault()
  #   link = $(e.currentTarget)
  #   link.data('show-duplicates', link.data('show-duplicates') ^ 1)
  #   fields_block = link.closest(".controls")
  #   fields_block.find('.value_field').each ->
  #     $(this).parent().removeClass('duplicate')
  #     if link.data('show-duplicates')
  #       fields_block.find('.value_field').not($(this)).filter("[name='" + this.name + "']").parent().addClass('duplicate')
  #   old_text = link.text()
  #   new_text = link.data('text')
  #   link.text(new_text).data('text', old_text)
  #   return false
