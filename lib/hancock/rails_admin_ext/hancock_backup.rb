require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class HancockBackup < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)


        register_instance_option :visible do
          bindings and bindings[:controller]._current_user and bindings[:controller]._current_user.admin?
        end

        register_instance_option :root? do
          true
        end

        register_instance_option :route_fragment do
          'backup'
        end

        register_instance_option :template_name do
          'hancock/backup'
        end

        register_instance_option :controller do
          Proc.new do
            path = "public/system/snapshots"
            if request.get?
  
            elsif request.post?
              if defined?(BackupJob)
                if params[:mongodump] == "1"
                  BackupJob.make_backup_later(operation: 'mongodump')
                else
                  BackupJob.make_backup_later
                end
              else
                Thread.new do
                  path = "public/system/snapshots"
                  t = Time.new.to_i
                  db_name = Mongoid.default_client.options[:database]
                  pub_path = "snapshot-#{t}/data.zip"
                  x = ".git/\\* log/\\* #{path}/snapshot-\\* tmp/\\*"
    
                  # touch     = "touch ./public/#{pub_path}"
                  # touch     = "mkdir -p #{path}/ ; rm ./#{path}/#{pub_path}"
                  touch     = "mkdir -p #{path}/snapshot-#{t} rm #{path}/snapshot-#{t}/*"
                  mongodump = "mongodump --db #{db_name}"
                  zip       = "zip -r ./#{path}/#{pub_path} . -x #{x} -s 50m"
                  rm        = "rm ./dump -rf"
                  puts "#{[touch, mongodump, zip, rm].join(" ; ")}"
                  `#{[touch, mongodump, zip, rm].join(" ; ")}`
                  puts "FINISHED"
                end
              end
              flash[:notice] = "Бэкап начат. В скором времени появится ссылка на архив."
              redirect_to backup_path
  
            elsif request.delete?
              if BackupJob
                BackupJob.make_remove_backup_later(snapshot: params[:snapshot])
                flash[:notice] = "Удаление бэкапа запущено. Ожидайте."
              else
                snapshot = params[:snapshot].to_i
                snapshot_file = "./#{path}/snapshot-#{snapshot}.zip"
                snapshot_path = "./#{path}/snapshot-#{snapshot}"
                if File.exists?(snapshot_file) or true
                  # if File.delete(snapshot_file)
                  begin
                    FileUtils.rm_rf(snapshot_file) 
                    FileUtils.rm_rf(snapshot_path)
                    flash[:notice] = "Бэкап удален."
                  rescue
                    flash[:error] = "Не удалось удалить бэкап."
                  end
                else
                  flash[:error] = "Бэкап не найден."
                end
              end
              redirect_to backup_path
            end
          end
        end

        register_instance_option :link_icon do
          'fa fa-cloud-upload'
          # 'fa fa-cloud-download'
        end

        register_instance_option :statistics? do
          false
        end

        register_instance_option :http_methods do
          [:get, :post, :delete]
        end
        
      end
    end
  end
end

