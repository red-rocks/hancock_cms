$(document).on 'rails_admin.dom_ready', ->
  $("input[type='checkbox']").each ->
    $(this).addClass('custom_checkbox').after '<span></span>'