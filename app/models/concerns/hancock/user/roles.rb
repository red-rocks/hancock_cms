module Hancock::User::Roles
  extend ActiveSupport::Concern

  included do

    field :roles,   type: Array, default: []

    before_save do
      self.roles ||= []
      self.roles.reject! { |r| r.blank? }
    end

    AVAILABLE_ROLES = ["admin", "manager", "client"].freeze

    AVAILABLE_ROLES.each do |r|
      class_eval <<-RUBY
        def #{r}?
          self.roles and self.roles.include?("#{r}")
        end

        scope :#{r.pluralize}, -> { any_in(roles: "#{r}") }
      RUBY
    end


    rails_admin do
      list do
        field :roles do
          pretty_value do
            render_object = (bindings[:controller] || bindings[:view])
            render_object.content_tag(:p, bindings[:object].roles.join(", ")) if render_object
          end
        end
      end

      edit do
        group :roles do
          active false
          field :roles, :hancock_enum do
            enum do
              ::User::AVAILABLE_ROLES
            end

            multiple do
              true
            end

            visible do
              render_object = (bindings[:controller] || bindings[:view])
              render_object and render_object.current_user.admin?
            end
          end
        end
      end

      specified_actions_for_collection do
        action :generate_first_manager_user do
          label do
            "Создать аккаунт #{User.default_manager_email}"
          end
          button_text "Создать"
          visible? do
            render_object = (bindings[:controller] || bindings[:view])
            !!(User.managers.all.count == 0) and 
              !!(render_object and (render_object.current_user.admin?))
          end
        end
      end if defined?(RailsAdminSpecifiedActions)
    end

  end


  class_methods do
    def default_admin_email; nil; end
    def generate_first_admin_user
      if ::User.admins.all.count == 0
        # _email_pass = 'admin@redrocks.pro'
        _email_pass = default_admin_email
        if _email_pass and ::User.new(roles: ["admin"], email: _email_pass, password: _email_pass, password_confirmation: _email_pass).save
          puts "#################################################################################"
          puts "#################################################################################"
          puts "AdminUser with email and password '#{_email_pass}' was created!"
          puts "#################################################################################"
          puts "#################################################################################"
          return true
        else
          puts 'Creating AdminUser error'
        end
      else
        puts 'AdminUsers are here already'
      end
      return false
    end

    def default_manager_email; nil; end
    def generate_first_manager_user
      if ::User.managers.all.count == 0
        # _email_pass = 'manager@redrocks.pro'
        _email_pass = default_manager_email
        if _email_pass and ::User.create(roles: ["manager"], email: _email_pass, password: _email_pass, password_confirmation: _email_pass)
          puts "ManagerUser with email and password '#{_email_pass}' was created!"
          return true
        else
          puts 'Creating ManagerUser error'
        end
      else
        puts 'ManagerUsers are here already'
      end
      return false
    end
  end
  

end
