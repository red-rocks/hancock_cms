# module Hancock
#   if Hancock.active_record?
#     class User < ActiveRecord::Base
#     end
#   end

#   class User
#     include Hancock::Models::User

#     include Hancock::Decorators::User

#     rails_admin(&Hancock::Admin::User.config(rails_admin_add_fields) { |config|
#       rails_admin_add_config(config)
#     })
#   end
# end




############ TEMP ###########default_admin_email
module Hancock
  class User
  end
end
