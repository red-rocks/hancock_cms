$(document).on "ajax:complete", "#cookies_policy_accept", (e)->
  e.preventDefault()
  $(e.currentTarget).closest("#cookie-notice").remove()
  retunrn false
