$(document).on "click", ".hancock_array_type .array_element_add_link", (e)->
  e.preventDefault()
  link = $(e.currentTarget)
  # link_parent = link.parent()
  link_parent = link#.parent()
  link_parent.before(link.data('template'))
  link_parent.prev().find('input:first').focus().select().trigger('change')
  return false


$(document).on 'click', '.hancock_array_type .array_element_delete_link', (e)->
  e.preventDefault()
  hidden_field = $(e.currentTarget).closest(".hancock_array_type").find("[type='hidden']")
  $(e.currentTarget).parent().remove()
  hidden_field.trigger('change')
  return false


$(document).on 'click', '.hancock_array_type .array_element_move_link', (e)->
  e.preventDefault()
  link = $(e.currentTarget)
  # array_element_block = link.parent()
  array_element_block = link.parent().parent()
  if link.hasClass("up")
    prev = array_element_block.prev(".array_element_block")
    array_element_block.insertBefore(prev) if prev.length > 0
  if link.hasClass("down")
    next = array_element_block.next(".array_element_block")
    array_element_block.insertAfter(next) if next.length > 0
  return false



$(document).on "change", ".hancock_array_type :input, .hancock_enum_type :input, .hancock_enum_with_custom_type :input, .enum_type :input", (e)->
  field_block = $(e.currentTarget).closest(".hancock_array_type, .hancock_enum_type, .hancock_enum_with_custom_type, .enum_type")
  hidden_field = field_block.find("[type='hidden']")
  if field_block.find(":input:not([type='hidden'])").serializeArray().length == 0
    hidden_field.prop('name', hidden_field.data('name')) if hidden_field.data('name')
  else
    hidden_field.data('name', hidden_field.prop('name')) if hidden_field.prop('name')
    hidden_field.prop('name', '')


$(document).on "rails_admin.dom_ready", (e)->
  $(".hancock_array_type, .hancock_enum_type, .hancock_enum_with_custom_type, .enum_type").find(":input[type='hidden']").trigger('change')
