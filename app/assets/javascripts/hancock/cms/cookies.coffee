$(document).on "ajax:complete", "#cookies_policy_accept", (e)->
  e.preventDefault()
  $(e.currentTarget).closest("#cookies_policy").remove()
  retunrn false
