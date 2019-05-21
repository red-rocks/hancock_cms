lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hancock/version'

Gem::Specification.new do |spec|
  spec.name          = 'hancock_cms'
  spec.version       = Hancock::VERSION
  spec.authors       = ['Alexander Kiseliev']
  spec.email         = ["dev@redrocks.pro"]
  spec.description   = %q{HancockCMS }
  spec.summary       = %q{Please DO NOT use this gem directly, use hancock_cms_mongoid or hancock_cms_activerecord instead!}
  spec.homepage      = 'https://github.com/red-rocks/hancock_cms'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/).reject {|f| f.start_with?('mongoid') || f.start_with?('activerecord') }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'

  spec.add_dependency 'rails', ['>= 6.0.0.beta3', '< 6.1.x']

  spec.add_dependency 'sprockets'#, '~> 3'

  spec.add_dependency 'jquery-rails'
  spec.add_dependency 'simple_form'

  # spec.add_dependency 'glebtv-simple_captcha'
  # spec.add_dependency 'galetahub-simple_captcha'

  spec.add_dependency 'coffee-rails'
  spec.add_dependency 'uglifier'
  

  spec.add_dependency 'devise'

  # spec.add_dependency 'ckeditor'
  spec.add_dependency 'geocoder'

  spec.add_dependency 'rails_admin'#, '1.3.0'
  spec.add_dependency 'rails_admin_nested_set'
  spec.add_dependency 'rails_admin_toggleable'#, '< 0.9.0'

  spec.add_dependency 'ack_rails_admin_settings', '>= 1.2.4.rc7', '< 1.3.1.x'
  spec.add_dependency 'safe_yaml'

  spec.add_dependency 'kaminari'
  spec.add_dependency 'kaminari-actionview'

  spec.add_dependency 'codemirror-rails'

  spec.add_dependency 'scrollbar-rails'
  spec.add_dependency 'stickykit-rails'

  spec.add_dependency 'rails_admin_jsoneditor'
end
