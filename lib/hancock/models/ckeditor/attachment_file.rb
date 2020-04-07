# frozen_string_literal: true

module Hancock::Ckeditor::AttachmentFile
  extend ActiveSupport::Concern

  included do

    include Hancock::Gallery::Shrineable
    hancock_cms_attached_file :data,
                              url: '/ckeditor_assets/attachments/:id/:filename',
                              path: ':rails_root/public/ckeditor_assets/attachments/:id/:filename'

    # validates_attachment_presence :data
    # validates_attachment_size :data, less_than: 100.megabytes
    # do_not_validate_attachment_file_type :data

    def url_thumb
      @url_thumb ||= Ckeditor::Utils.filethumb(filename)
    end


    rails_admin do
      field :c_at do
        read_only true
      end
      field :data, :hancock_shrine
      field :width, :integer
      field :height, :integer
    end

  end
end
