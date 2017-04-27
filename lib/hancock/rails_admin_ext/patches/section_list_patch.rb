require 'rails_admin/config/sections/list'
module RailsAdmin
  module Config
    module Sections
      # Configuration of the list view
      class List < RailsAdmin::Config::Sections::Base

        register_instance_option :sort_by do
          # _fields = parent.abstract_model.model.fields.keys
          # ret = :order if _fields.include?(:order)
          # ret ||= :lft if _fields.include?(:lft)
          # # ret ||= :counter if _fields.include?(:counter)
          # ret ||= parent.abstract_model.primary_key
          # ret
        end

        register_instance_option :sort_reverse? do
          true # By default show latest first
        end

        register_instance_option :scopes do
          _model_scopes = parent.abstract_model.model.scopes.keys
          _possible_scopes = [:sorted, :by_date, :enabled]
          (_possible_scopes & _model_scopes ) + [nil]
        end

      end
    end
  end
end
