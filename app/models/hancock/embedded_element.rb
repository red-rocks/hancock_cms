module Hancock
  if Hancock.mongoid?
    class EmbeddedElement
      include Hancock::Models::EmbeddedElement

      include Hancock::Decorators::EmbeddedElement

      rails_admin(&Hancock::Admin::EmbeddedElement.config(rails_admin_add_fields) { |config|
        rails_admin_add_config(config)
      })

      # use it in rails_admin in parent model for sort
      # sort_embedded({fields: [:embedded_field_1, :embedded_field_2...]})
      # or u need to override rails_admin in inherited model to add sort field
    end
  end
end
# 
# counter = 0
# 1_000_000.times do |i|
#   i = i.to_s
#   next if i.length < 6
#   i = i.split("").uniq
#   next if i.length < 6
#   next if i.include?("0")
#   next if i.include?("7")
#   next if i.include?("8")
#   next if i.include?("9")
#   next if i[0] != '1'
#   next if i[1] != '2'
#   next if i[2] != '3'
#   puts i.join
#   counter += 1
# end
# puts counter
