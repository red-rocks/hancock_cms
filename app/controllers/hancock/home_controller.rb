module Hancock
  class HomeController < ApplicationController

    def index
      _layout = (request.xhr? ? false : Hancock.config.main_index_layout)
      render layout: _layout
    end

    def privacy_policy
      _layout = (request.xhr? ? false : Hancock.config.main_index_layout)
      render layout: _layout
    end

    def cookies_policy
      _layout = (request.xhr? ? false : Hancock.config.main_index_layout)
      render layout: _layout
    end
    def cookies_policy_accept
      session[:cookies_notification_was_accepted] = true
      render nothing: true
    end

    include Hancock::Decorators::Home
  end
end
