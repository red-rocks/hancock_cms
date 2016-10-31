module Hancock::Errors
  extend ActiveSupport::Concern
  included do
    if Rails.env.production? || Rails.env.staging? || (respond_to?(:hancock_check_errors) and hancock_check_errors)
      rescue_from Exception, with: :render_500
      rescue_from ActionController::RoutingError, with: :render_404
      rescue_from ActionController::UnknownController, with: :render_404
      rescue_from ActionController::MissingFile, with: :render_404
      rescue_from AbstractController::ActionNotFound, with: :render_404
      if Hancock.mongoid?
        rescue_from Mongoid::Errors::DocumentNotFound, with: :render_404
        rescue_from Mongoid::Errors::InvalidFind, with: :render_404
      end
      if Hancock.active_record?
        rescue_from ActiveRecord::RecordNotFound, with: :render_404
      end
    end

    if defined?(CanCan)
      rescue_from CanCan::AccessDenied do |exception|
        Rails.logger.error "__________________________".freeze
        Rails.logger.error "Error 403".freeze
        Rails.logger.error (params ? params.inspect : "no params data".freeze)
        Rails.logger.error (current_user ? current_user.inspect : "no current_user".freeze)
        unless exception.nil?
          Rails.logger.error exception.message
          Rails.logger.error exception.backtrace.join("\n")
          capture_exception(exception) if defined?(Raven)
        end
        Rails.logger.error "__________________________"
        if !user_signed_in?
          #scope = rails_admin? ? main_app : self
          #redirect_to scope.new_user_session_path, alert: "Необходимо авторизоваться"
          authenticate_user!
        else
          redirect_to '/', alert: t('hancock.errors.access_denied')
        end
      end
    end

    rescue_from ActionController::InvalidAuthenticityToken do |exception|
      redirect_to :back, alert: t('hancock.errors.form_expired')
    end
  end

  private
  def render_404(exception = nil)
    Rails.logger.error "__________________________".freeze
    Rails.logger.error "Error 404".freeze
    Rails.logger.error (params ? params.inspect : "no params data".freeze)
    Rails.logger.error (current_user ? current_user.inspect : "no current_user".freeze)
    unless exception.nil?
      Rails.logger.error exception.message
      Rails.logger.error exception.backtrace.join("\n")
      capture_exception(exception) if defined?(Raven)
    end
    Rails.logger.error "__________________________".freeze
    render_error(404)
  end

  def render_500(exception = nil)
    Rails.logger.error "__________________________".freeze
    Rails.logger.error "Error 500".freeze
    Rails.logger.error (params ? params.inspect : "no params data".freeze)
    Rails.logger.error (current_user ? current_user.inspect : "no current_user".freeze)
    unless exception.nil?
      Rails.logger.error exception.message
      Rails.logger.error exception.backtrace.join("\n")
      capture_exception(exception) if defined?(Raven)
    end
    Rails.logger.error "__________________________".freeze
    begin
      if rails_admin?
        render text: t('hancock.errors.internal_error_full', klass: exception.class.name, message: exception.message), status: 500
        return
      end
    rescue Exception => e
      puts "error while rendering rails admin exception".freeze
      puts e.class.name
      puts e.message
      puts e.backtrace.join("\n")
    end
    render_error(500)
  end

  def render_error(code = 500)
    render template: "hancock/errors/error_#{code}", formats: [:html], handlers: [:slim], layout: Hancock.config.error_layout, status: code
  end
  
end
