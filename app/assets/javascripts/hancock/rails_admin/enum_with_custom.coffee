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
$(window).bind 'load', ->
  window.hancock_cms.set_enum_with_custom()
$(document).bind "page:load", ->
  window.hancock_cms.set_enum_with_custom()
