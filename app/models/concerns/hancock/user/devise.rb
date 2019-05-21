module Hancock::User::Devise
  extend ActiveSupport::Concern

  included do

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable,  :lockable,
      :recoverable, :rememberable, :validatable

    ## Database authenticatable
    field :email,              type: String, default: ""
    field :encrypted_password, type: String, default: ""

    ## Recoverable
    field :reset_password_token,   type: String
    field :reset_password_sent_at, type: Time

    ## Rememberable
    field :remember_created_at, type: Time

    ## Trackable
    # field :sign_in_count,      type: Integer, default: 0
    # field :current_sign_in_at, type: Time
    # field :last_sign_in_at,    type: Time
    # field :current_sign_in_ip, type: String
    # field :last_sign_in_ip,    type: String

    ## Confirmable
    # field :confirmation_token,   type: String
    # field :confirmed_at,         type: Time
    # field :confirmation_sent_at, type: Time
    # field :unconfirmed_email,    type: String # Only if using reconfirmable

    ## Lockable
    field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
    field :unlock_token,    type: String # Only if unlock strategy is :email or :both
    field :locked_at,       type: Time

    field :name,    type: String
    field :login,   type: String



    rails_admin do
      list do
        field :email
        field :login
      end
  
      edit do
        group :login do
          active false
          field :email, :string do
            visible do
              render_object = (bindings[:controller] || bindings[:view])
              render_object and (render_object.current_user.admin? or (render_object.current_user.manager? and render_object.current_user == bindings[:object]))
            end
          end
          field :login, :string do
            visible do
              render_object = (bindings[:controller] || bindings[:view])
              render_object and render_object.current_user.admin?
            end
          end
        end
        

        group :password do
          active false
          field :password do
            visible do
              render_object = (bindings[:controller] || bindings[:view])
              render_object and (render_object.current_user.admin? or render_object.current_user == bindings[:object])
            end
          end
          field :password_confirmation do
            visible do
              render_object = (bindings[:controller] || bindings[:view])
              render_object and (render_object.current_user.admin? or render_object.current_user == bindings[:object])
            end
          end
        end

      end
      
  
    end

  end
  

end
