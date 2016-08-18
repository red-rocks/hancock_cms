module Hancock
  class HomeController < ApplicationController

    def index
      render layout: Hancock.config.main_index_layout
    end

    include Hancock::Decorators::Home
  end
end
