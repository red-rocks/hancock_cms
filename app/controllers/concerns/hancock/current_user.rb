module Hancock::Errors
  extend ActiveSupport::Concern

  included do
    before_action :set_current_user

    def set_current_user
      User.current_user = current_user
    end
  end

end
