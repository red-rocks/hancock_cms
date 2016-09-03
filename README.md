# HancockCMS

#### Inspired by [RocketCMS](https://github.com/rs-pro/rocket_cms)
### Remaded from [EnjoyCMS](https://github.com/enjoycreative/enjoy_cms)

# DEVELOPMENT VERSION

Rails + RailsAdmin + Mongoid/PostgreSQL CMS

Very opinionated and tuned for my needs.

## Installation

Add this line to your application's Gemfile:

    gem 'hancock_cms_mongoid'

or:

    gem 'hancock_cms_activerecord'

*Only PostgreSQL is tested or supported for AR(from root repo). Others will probably work, but untested.*

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hancock_cms

For activerecord, generate migrations and run them

    rails g rails_admin_settings:migration
    rails g hancock_cms:migration
    rake db:migrate

## Usage

### Using app generator

Make sure you have rails 5.0 installed

    rails -v

If not, uninstall rails and install again

    gem uninstall rails
    gem install hancock_cms

Then, for mongoid:

    rails new my_app -T -O -m https://raw.githubusercontent.com/red-rocks/hancock_cms/master/template.rb

for ActiveRecord:

    rails new my_app -T --database=postgresql -m https://raw.githubusercontent.com/red-rocks/hancock_cms/master/template.rb

generator creates a new RVM gemset, so after cd'ing to app dir, you should run `bundle install` again if you use rvm.

### Localization

All models included in the gem support localization via either [hstore_translate](https://github.com/Leadformance/hstore_translate) or built-in Mongoid localize: true option.

You can get a nice admin UI for editing locales by adding [rails_admin_hstore_translate](https://github.com/glebtv/rails_admin_hstore_translate) or [rails_admin_mongoid_localize_field](https://github.com/sudosu/rails_admin_mongoid_localize_field)

<!-- Wrap your routes with locale scope:
```ruby
scope "(:locale)", locale: /en|ru/ do
  hancock_cms_routes
end
``` -->

Enable localization in HancockCMS:

```ruby
Hancock.configure do |hancock|
  hancock.localize = true
  ...
end
```

Add ```rails_admin_hstore_translate``` or ```hstore_translate``` gem if using PostgreSQL:

```ruby
gem 'rails_admin_hstore_translate'
```

or

```ruby
gem 'hstore_translate'
```

Add ```rails_admin_mongoid_localize_field``` gem if using MongoDB:

```ruby
gem 'rails_admin_mongoid_localize_field'
```

### Documentation

It's basically Mongoid + Rails Admin + some of my common models and controllers, etc.

See their documentation for more info

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
