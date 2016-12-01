lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'hancock/version'

Gem::Specification.new do |spec|
  spec.name          = 'hancock_cms_mongoid'
  spec.version       = Hancock::VERSION
  spec.authors       = ['Alexander Kiseliev']
  spec.email         = ["dev@redrocks.pro"]
  
  spec.description   = %q{HancockCMS - Mongoid metapackage}
  spec.summary       = %q{}
  spec.homepage      = 'https://github.com/red-rocks/hancock_cms'
  spec.license       = 'MIT'

  spec.files         = %w(lib/hancock_cms_mongoid.rb)
  spec.executables   = []
  spec.test_files    = []
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'

  spec.add_dependency 'mongoid', ['>= 5.0.0', '< 6.0']
  spec.add_dependency 'hancock_cms', Hancock::VERSION

  spec.add_dependency 'glebtv-mongoid_nested_set'
  spec.add_dependency 'rails_admin_sort_embedded'

  spec.add_dependency 'mongoid-audit', '~> 1.3.0'
  spec.add_dependency 'mongoid-slug', '~> 5.2.0'

  spec.add_dependency 'mongo_session_store-rails4'

  spec.add_dependency "rails_admin_mongoid_localize_field"

  spec.add_dependency 'kaminari-mongoid'

  spec.add_dependency 'glebtv_mongoid_userstamp', '0.6.0'
end
