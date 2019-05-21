module Hancock::User::GoogleAuthenticator
  extend ActiveSupport::Concern

  included do 


    include GoogleAuthenticatorRails::Mongoid::ActsAsGoogleAuthenticated
    def default_google_label_method
      (Rails.env.production? ? "vg-media.ru: #{email}" : "local.vg-media.ru: #{email}")
    end


    acts_as_google_authenticated encrypt_secrets: true
    field :use_google_auth, type: Boolean, default: false 
    def google_auth?
      !!(use_google_auth and !google_secret.blank?)
    end

    rails_admin do

      edit do
        group :google_auth do
          active false
          field :use_google_auth, :toggle do
            visible do
              render_object = (bindings[:controller] || bindings[:view])
              !!(render_object and (render_object.current_user.admin? or render_object.current_user == bindings[:object]))
            end
            help do
              "Общая настройка GoogleAuth: #{Settings.google_auth(default: true, kind: :boolean, for_admin: true)}."
            end
          end
          field :google_secret, :string do
            visible do
              render_object = (bindings[:controller] || bindings[:view])
              !!(render_object and (render_object.current_user.admin?))
            end
            read_only true
            help do
              if bindings and bindings[:object]
                uri = bindings[:object].google_qr_uri
                "<a href='#{uri}' target='_blank'><img src='#{uri}'</img></a>".html_safe
              end
            end
          end
        end
      end

      specified_actions_for_member do
        action :set_google_secret do
          label do
            'Зарегистрировать в Google Authenticator'
          end
          button_text "Зарегистрировать"
          visible? do
            render_object = (bindings[:controller] || bindings[:view])
            !!(bindings and bindings[:object] and !bindings[:object].google_auth?) and 
              !!(render_object and (render_object.current_user.admin?))
          end
        end
      end
    end

  end
  

end
