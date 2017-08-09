module Hancock
  class HomeController < ApplicationController

    def index
      render layout: Hancock.config.main_index_layout
    end

    def privacy_policy
      render layout: Hancock.config.main_index_layout
    end

    def cookies_policy
      render layout: Hancock.config.main_index_layout
    end
    def cookies_policy_accept
      session[:cookies_notification_was_accepted] = true
      render nothing: true
    end

    include Hancock::Decorators::Home
  end
end
