# frozen_string_literal: true

module Hancock::Ckeditor::Picture < Ckeditor::Asset
  extend ActiveSupport::Concern

  included do
  
    # has_mongoid_attached_file :data,
    #                           url: '/ckeditor_assets/pictures/:id/:style_:basename.:extension',
    #                           path: ':rails_root/public/ckeditor_assets/pictures/:id/:style_:basename.:extension',
    #                           styles: { content: '800>', thumb: '118x100#' }


    # include Hancock::Gallery::Paperclipable
    # hancock_cms_attached_file :data,
    #                           url: '/ckeditor_assets/pictures/:id/:style/:basename.:extension',
    #                           path: ':rails_root/public/ckeditor_assets/pictures/:id/:style/:basename.:extension'
    # validates_attachment_size :data, less_than: 2.megabytes
    # validates_attachment_presence :data
    # validates_attachment_content_type :data, content_type: /\\Aimage/

    include Hancock::Gallery::Shrineable
    hancock_cms_attached_file :data

    def data_styles
      if data and data.svg?
        {}
      else
        { 
          content: '800>',
          thumb: '118x100#',
          webp: {
            geometry: "1080>",
            format: :webp
          },
          amp: {
            geometry: "720>",
            format: :webp
          }
        }
      end
    end
    def data_crop_options
      {
        crop_style: :thumb 
      }
    end

    
    def url_content
      # url(:content)
      if data and data.svg?
        data.url
      else
        data(:content).url
        # data[:content].url
      end
    end

    def url_thumb
      # url(:thumb)
      if data and data.svg?
        url.url
      else
        data(:thumb).url
        # data[:thumb].url
      end
    end

    def url_webp
      # url(:webp)
      if data and data.svg?
        data.url
      else
        data(:webp).url
        # data[:webp].url
      end
    end

    def url_amp
      # url(:amp)
      if data and data.svg?
        data.url
      else
        data(:amp).url
        # data[:amp].url
      end
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
