module Hancock::User::Authy
  extend ActiveSupport::Concern

  included do

    field :cellphone, type: String, default: ""
    def authy_cellphone
      parts = cellphone.scan(/^(8|\+7)(\d{3})(\d{3})(\d{2})(\d{2})$/)
      ret = {}
      if parts
        parts = parts.shift
        if parts
          parts.shift # remove (8|\+7)
          ret[:country_code] = "7" 
          ret[:cellphone] = parts.join("-")
        end
      end
      ret
    end

    field :authy_id  
    field :use_authy, type: Boolean, default: false 
    def authy?
      !!(use_authy and !authy_id.blank?)
    end
    def authy_register(opts = {})
      unless authy?
        authy = Authy::API.register_user(authy_cellphone.merge({email: self.email}).merge(opts))

        if authy.ok?
          self.authy_id = authy.id # this will give you the user authy id to store it in your database
          self.save
        else
          authy.errors # this will return an error hash
        end
      end
    end
    def authy_verify?(token_2fa = self.token_2fa)
      Authy::API.verify(:id => authy_id, :token => token_2fa)
    end

    rails_admin do
      edit do
        group :authy do
          active false
          field :use_authy, :toggle do
            visible do
              render_object = (bindings[:controller] || bindings[:view])
              !!(render_object and (render_object.current_user.admin? or render_object.current_user == bindings[:object]))
            end
            help do
              "Общая настройка Authy: #{Settings.authy(default: true, kind: :boolean, for_admin: true)}. API Key: #{!Authy.api_key.blank?}."
            end
          end
          field :authy_id do
            visible do
              render_object = (bindings[:controller] || bindings[:view])
              !!(render_object and (render_object.current_user.admin?))
            end
            help do
              (bindings and bindings[:object] and bindings[:object].authy_cellphone.inspect)
            end
          end
          field :cellphone do
            visible do
              render_object = (bindings[:controller] || bindings[:view])
              !!(render_object and (render_object.current_user.admin? or render_object.current_user == bindings[:object]))
            end
          end
        end
      end

      specified_actions_for_member do
        action :authy_register do
          label do
            'Зарегистрировать в Authy'
          end
          button_text "Зарегистрировать"
          visible? do
            render_object = (bindings[:controller] || bindings[:view])
            !!(bindings and bindings[:object] and !bindings[:object].authy?) and 
              !!(render_object and (render_object.current_user.admin?))
          end
        end
      end
    end

  end
  

end
