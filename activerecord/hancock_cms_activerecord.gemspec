lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'hancock/version'

Gem::Specification.new do |spec|
  spec.name          = 'hancock_cms_activerecord'
  spec.version       = Hancock::VERSION
  spec.authors       = ['Alexander Kiseliev']
  spec.email         = "dev@redrpcks.pro"
  spec.description   = %q{HancockCMS - ActiveRecord metapackage}
  spec.summary       = %q{}
  spec.homepage      = 'https://github.com/red-rocks/hancock_cms'
  spec.license       = 'MIT'

  spec.files         = %w(lib/hancock_cms_activerecord.rb)
  spec.executables   = []
  spec.test_files    = []
  spec.require_paths = ['lib']

  spec.add_dependency 'hancock_cms', Hancock::VERSION
  spec.add_dependency 'awesome_nested_set'
  spec.add_dependency 'paperclip'
  spec.add_dependency 'paper_trail'
  spec.add_dependency 'friendly_id'
  spec.add_dependency "validates_lengths_from_database"
  spec.add_dependency 'foreigner'
  spec.add_dependency 'pg_search'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'

  spec.add_development_dependency 'activerecord-session_store'

  spec.add_dependency 'kaminari'
end
