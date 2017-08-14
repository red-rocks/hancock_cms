$(document).on 'ready', ->
  $("input[type='checkbox']").each ->
    $(this).addClass('custom_checkbox').after '<span></span>'