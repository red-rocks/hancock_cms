window.hancock_cms.multiselect_dblclick = (selector)->
  $(document).on 'dblclick', selector + ' .ra-multiselect-left select option', (e)->
    $(e.currentTarget).closest('.ra-multiselect').find('.ra-multiselect-center .ra-multiselect-item-add').click()

  $(document).on 'dblclick', selector + ' .ra-multiselect-right select option', (e)->
    $(e.currentTarget).closest('.ra-multiselect').find('.ra-multiselect-center .ra-multiselect-item-remove').click()

window.hancock_cms.multiselect_dblclick("select.hancock_multiselect + .ra-multiselect, select.hancock_enum + .ra-multiselect")
