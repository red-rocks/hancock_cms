$(document).on 'rails_admin.dom_ready', ->
  $("input[type='checkbox']:not(.custom_checkbox):not(.delete-checkbox)").each ->
    $(this).addClass('custom_checkbox').after('<span></span>')
