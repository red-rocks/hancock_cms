window.hancock_cms.set_enum_with_custom = () ->
  $('.hancock_enum_with_custom_type .ra-filtering-select-input').autocomplete(
    search: (e, ui)->
      if e.currentTarget
        $(e.currentTarget).closest(".controls").find("select.hancock_enum option:first").val(e.currentTarget.value).text(e.currentTarget.value)
        _src = $(e.currentTarget).closest(".controls").find("select.hancock_enum option").map( ->
          { label: $(this).text(), value: $(this).text() }
        ).toArray();
        $(e.currentTarget).closest(".controls").find("select").data('raFilteringSelect').options.source = _src
  )
  $('.hancock_enum_with_custom_type .ra-multiselect-search').on('keydown', (e)->
    if e.which == 13
      e.preventDefault()
      me = $(e.currentTarget)
      new_item_text = me.val().trim()
      return false if new_item_text.length == 0
      parent_block = me.closest(".ra-multiselect")
      left_collection   = parent_block.find(".ra-multiselect-left .ra-multiselect-collection")
      right_collection  = parent_block.find(".ra-multiselect-right .ra-multiselect-selection")
      found_item = null
      left_collection.find("option").each ->
        found_item = $(this) if this.value == new_item_text
        return !found_item
      unless found_item
        right_collection.find("option").each ->
          found_item = $(this) if this.value == new_item_text
          return !found_item
        return false if found_item
        left_collection.append(found_item = $('<option></option>').attr('value', new_item_text).attr('title', new_item_text).text(new_item_text))
      found_item.prop('selected', true).trigger('dblclick')

      return false
  ).each ->
    onclick = '$(this).siblings(".ra-multiselect-search").trigger($.Event("keydown", {which: 13}));return false;'
    # onclick = '$(this).siblings(".ra-multiselect-search").keydown({which: 13});return false;'
    $(this).after("<a class='hancock_enum_with_custom_type_add_button' href='#' onclick='" + onclick + "' title='Добавить'>+</a>")


$(document).on 'rails_admin.dom_ready', ->
  window.hancock_cms.set_enum_with_custom()
