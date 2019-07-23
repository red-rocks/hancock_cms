#= require_self

#= require ./custom_checkboxes

#= require jquery.sticky-kit.js
#= require simplebar

# require ./form_controls_fixed

#= require ./navigation_dropdown
#= require ./blocks/aside/navigation_filter
#= require ./navigation_hider

#= require ./multiselect
#= require ./enum_with_custom

#= require ./hancock_array
#= require ./hancock_hash

#= require ./management

#= require ./hancock_tabbed_edit


#= require ./plugins

window.hancock_cms ||= {}


$(document).on 'click', '#aside .aside-toggler', ()->
  $('body').toggleClass('aside-minimized')
  window.localStorage.setItem('asideMinimized', $('body').hasClass('aside-minimized'))

$(document).on 'turbolinks:before-render', (e) ->
  event = e.originalEvent
  if window.localStorage.asideMinimized and window.localStorage.asideMinimized isnt 'false'
    if event
      $(event.data.newBody).addClass('aside-minimized')

$(document).on 'DOMContentLoaded', (e) ->
  if window.localStorage.asideMinimized and window.localStorage.asideMinimized isnt 'false'
    $('body').addClass('aside-minimized')

$(document).on 'mouseenter', 'body.aside-minimized #aside', () ->
  $(this).addClass('aside-fixed')

$(document).on 'mouseleave', 'body.aside-minimized #aside', () ->
  $(this).removeClass('aside-fixed')
