# $(document).on "#hancock_management_commands form", "submit", (e)->
#   e.preventDefault()
#   form = $(e.currentTarget)
#   button = form.find(".hancock_management_script")
#   command_block = form.closest(".command_block")
#   status_block = command_block.find(".status")
#   $.post form.serialize(), (data)->
#     status_block.html(data)
