# require "webpacker/configuration"
# require "webpacker/lib/webpacker/configuration"
# require "webpacker/lib/webpacker/configuration.rb"


say "Copying assets"

# say "Copying packs"
# assets_path = File.expand_path("../../app/assets", __dir__)
# packs_path = File.join(assets_path, "javascripts")
# packs_mask = File.join(packs_path, "**/*.*")
# Dir.glob(packs_mask).each do |file|
#   dir, filename = File.dirname(file), file.gsub(packs_path, "")
#   dest = File.join("#{Webpacker.config.source_entry_path}/", filename)
#   say "#{file} -> #{dest}"
#   copy_file file, dest
#   say filename
#   if filename == '/hancock/cms.coffee'
#     say 'hancock/cms.coffee fixes'
#     gsub_file dest, "#= require jquery2", "# require jquery2"
#     gsub_file dest, "#= require jquery_ujs", "# require jquery_ujs"
#     gsub_file dest, "#= require turbolinks", "# require turbolinks"
#     # gsub_file dest, "#= require ../head.load.js", "# require ../head.load.js"
#     # gsub_file dest, "#= require ../jquery.placeholder.js", "# require ../jquery.placeholder.js"
#     gsub_file dest, /#= require (\..*)$/, "import '\\1'"
    
#   end
# end

# say "Copying fonts"
# fonts_path = File.join(assets_path, "fonts")
# fonts_mask = File.join(fonts_path, "**/*.*")
# Dir.glob(fonts_mask).each do |file|
#   dir, filename = File.dirname(file), file.gsub(fonts_path, "")
#   dest = File.join("#{Webpacker.config.source_path}/fonts", filename)
#   say "#{file} -> #{dest}"
#   copy_file file, dest
# end

# say "Copying styles"
# styles_path = File.join(assets_path, "stylesheets")
# styles_mask = File.join(styles_path, "**/*.*")
# Dir.glob(styles_mask).each do |file|
#   dir, filename = File.dirname(file), file.gsub(styles_path, "")
#   dest = File.join("#{Webpacker.config.source_path}/styles", filename)
#   say "#{file} -> #{dest}"
#   copy_file file, dest
# end

# say "Copying images"
# images_path = File.join(assets_path, "images")
# images_mask = File.join(images_path, "**/*.*")
# Dir.glob(images_mask).each do |file|
#   dir, filename = File.dirname(file), file.gsub(images_path, "")
#   dest = File.join("#{Webpacker.config.source_path}/images", filename)
#   say "#{file} -> #{dest}"
#   copy_file file, dest
# end

