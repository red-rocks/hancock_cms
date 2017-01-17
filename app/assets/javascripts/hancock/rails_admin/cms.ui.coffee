#= require_self
#= require ./navigation_dropdown
#= require ./navigation_scroll
#= require ./navigation_filter

window.hancock_cms ||= {}
window.hancock_cms.multiselect_dblclick = (selector)->
  $(document).delegate selector + ' .ra-multiselect-left select option', 'dblclick', (e)->
    $(e.currentTarget).closest('.ra-multiselect').find('.ra-multiselect-center .ra-multiselect-item-add').click()

  $(document).delegate selector + ' .ra-multiselect-right select option', 'dblclick', (e)->
    $(e.currentTarget).closest('.ra-multiselect').find('.ra-multiselect-center .ra-multiselect-item-remove').click()

window.hancock_cms.multiselect_dblclick("select.hancock_multiselect + .ra-multiselect, select.hancock_enum + .ra-multiselect")
