#= require_self
#= require hancock/rails_admin/cms.ui
#= require hancock/rails_admin/custom/ui





#TODO

################# menu list-levels #################

addClasses = (list, level) ->
  list.addClass 'nav-level-' + level
  if list.children('li').children('ul').length
    addClasses list.children('li').children('ul'), level + 1

$(document).on 'rails_admin.dom_ready', ->
  addClasses($('#aside-menu ul.nav'), 1)
