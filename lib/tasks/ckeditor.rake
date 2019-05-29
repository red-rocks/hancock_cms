require 'fileutils'

namespace :ckeditor do
  desc 'Create nondigest versions of all ckeditor digest assets'
  task nondigest: :environment do
    fingerprint = /\-[0-9a-f]{32,64}\./
    path = Rails.root.join("public#{Ckeditor.base_path}**/*")

    Dir[path].each do |file|
      next unless file =~ fingerprint
      nondigest = file.sub fingerprint, '.'

      if !File.exist?(nondigest) || File.mtime(file) > File.mtime(nondigest)
        FileUtils.cp file, nondigest, verbose: true, preserve: true
      end
    end
  end
end

# Based on rake task from asset_sync gem
if Rake::Task.task_defined?("assets:precompile")
  Rake::Task["assets:precompile"].enhance do
    Rake::Task["ckeditor:nondigest"].invoke if defined?(CKEditor)
  end
end
