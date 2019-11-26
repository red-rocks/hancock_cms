window.hancock.multiselect_dblclick = (selector)->
  left_selector = []
  right_selector = []
  selector.split(",").forEach (sel)->
    left_selector.push(sel + ' .ra-multiselect-left select option')
    right_selector.push(sel + ' .ra-multiselect-right select option')
  left_selector = left_selector.join(", ")
  right_selector = right_selector.join(", ")

  $(document).on 'dblclick', left_selector, (e)->
    $(e.currentTarget).closest('.ra-multiselect').find('.ra-multiselect-center .ra-multiselect-item-add').click()
  $(document).on 'dblclick', right_selector, (e)->
    $(e.currentTarget).closest('.ra-multiselect').find('.ra-multiselect-center .ra-multiselect-item-remove').click()


window.hancock.multiselect_dblclick("select.hancock_multiselect + .ra-multiselect, select.hancock_enum + .ra-multiselect")
