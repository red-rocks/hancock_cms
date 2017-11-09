require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class HancockManagement < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :root? do
          true
        end

        register_instance_option :route_fragment do
          'manage'
        end

        register_instance_option :template_name do
          'hancock_management'
        end

        register_instance_option :controller do
          Proc.new do
            verify_authenticity_token

            def get_lock_filename(script)
              Rails.root.join("tmp", "#{script}.lock").to_s
            end
            def get_script_filename(script)
              Rails.root.join("scripts", "#{script}.sh").to_s
            end
            def parse_status_string(status)
              return {} if status.blank?
              status = status.split(" ", 2)
              {
                thread_id: status[0].to_i,
                timestamp: status[1]
              }.compact
            end

            @scripts = %w(  assets_precompile
                            full_assets_precompile
                            bundle_production
                            bundle_production2

                            restart_thru_kill
                            send_usr2
                            send_hup

                            db_dump
                            db_restore
            )

            # safety version
            @scripts -= %w(  db_dump
                            db_restore
            )

            @scripts.select! { |s|
              File.exist?(get_script_filename(s))
            }
            #################

            if request.get?
              @script_statuses = {}
              @scripts.each { |s|
                lock_filename = get_lock_filename(s)
                @script_statuses[s] = ((File.exist?(lock_filename) ? File.read(lock_filename) : nil) rescue nil)
                if @script_statuses[s]
                  @script_statuses[s] = {
                    status: @script_statuses[s],
                    parsed_status: parse_status_string(@script_statuses[s])
                  }
                end
              }
              render action: @action.template_name

            else
              error = nil
              notice = nil
              begin

                if @scripts.include?(params[:do_script])
                  do_script = @scripts[@scripts.index(params[:do_script])]

                  lock_filename = get_lock_filename(do_script)
                  script_filename = get_script_filename(do_script)
                  unless File.exist?(lock_filename)
                    Thread.new(lock_filename, script_filename) do |lock_filename, script_filename|
                      begin
                        File.write(lock_filename, "#{Thread.current.object_id} (#{Russian::strftime Time.new})")
                        system(script_filename)
                      ensure
                        File.delete(lock_filename)
                      end
                    end
                  else
                    error ||= t("admin.actions.hancock_management.already_started")
                    error += " #{File.read(lock_filename)}."
                  end

                elsif (kill_thread = params[:kill_thread]).present?
                  kill_thread = kill_thread.to_i
                  Thread.list.each do |t|
                    t.kill if t.object_id == kill_thread
                  end
                  notice = t("admin.actions.hancock_management.thread_killed")

                else
                  error ||= t("admin.actions.hancock_management.unknown_script")
                end

              rescue Exception => ex
                error = ex.message
                error ||= t("admin.actions.hancock_management.unknown_error")
              end

              if error.blank?
                flash[:notice]  = notice || t("admin.actions.hancock_management.success")
              else
                flash[:error]   = error
              end

              redirect_to hancock_management_path
            end
          end
        end

        register_instance_option :link_icon do
          'fa fa-sitemap'
        end

        register_instance_option :statistics? do
          false
        end

        register_instance_option :http_methods do
          [:get, :post]
        end
      end
    end
  end
end
