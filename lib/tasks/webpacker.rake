# namespace :webpacker do
#   namespace :install do
#     desc "Install everything needed for HancockCMS"
#     task :hancock => ["webpacker:verify_install"] do
#       template = File.expand_path("../hancock/webpacker.rb", __dir__)

#       bin_path = "./bin"
#       base_path =
#         if Rails::VERSION::MAJOR >= 5
#           "#{RbConfig.ruby} #{bin_path}/rails app:template"
#         else
#           "#{RbConfig.ruby} #{bin_path}/rake rails:template"
#         end

#       # dependencies[name] ||= []
#       # dependencies[name].each do |dependency|
#       #   dependency_template = File.expand_path("../install/#{dependency}.rb", __dir__)
#       #   system "#{base_path} LOCATION=#{dependency_template}"
#       # end

#       exec "#{base_path} LOCATION=#{template}"
#     end
#   end
# end