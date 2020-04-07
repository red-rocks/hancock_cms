# frozen_string_literal: true

module Hancock::Ckeditor::Asset
  extend ActiveSupport::Concern

  included do

    include Hancock::Model

    include Ckeditor::Orm::Mongoid::AssetBase
    # include Mongoid::Paperclip
    # include Ckeditor::Backend::Paperclip
    include Ckeditor::Backend::Shrine

    include Hancock::Gallery::Shrineable
    hancock_cms_attached_file :data, is_image: false


    field :_type, type: String, default: nil, overwrite: true
    alias_method :asset_type, :_type
    def asset_type=(__type)
      self._type = __type
      self._type = nil if self._type.blank? or self._type == "Ckeditor::Asset"
    end

    def data_crop_options
    end


    rails_admin do
      field :asset_type, :hancock_enum do
        # visible do; false; end
        visible do
          bindings and bindings[:controller] and bindings[:controller]._current_user and bindings[:controller]._current_user.admin?
        end
        enum do
          ([Ckeditor::Asset] + Ckeditor::Asset.descendants).map(&:name)
        end
        multiple do
          false
        end
        method_name do
          :_type
        end
      end

      field :c_at do
        read_only true
      end
      field :data, :hancock_shrine
      field :width, :integer
      field :height, :integer
    end
  end
  
end
