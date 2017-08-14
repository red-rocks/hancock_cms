$(document).on "blur", ".devise-box form :input", (e)->
  input = $(e.currentTarget)
  if input.val().length > 0
    input.closest(".form-control").addClass("opened")
  else
    input.closest(".form-control").removeClass("opened")
