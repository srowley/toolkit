# RSpec setup
gem_group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

gem_group :development do
  gem 'guard-rspec'
end

gem_group :test do
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
end

inject_into_file "config/application.rb", \
  after: "class Application < Rails::Application\n" do
    <<-TEXT
    config.generators do |g|
      g.test_framework :rspec, 
      fixtures: true,
      view_specs: false,
      helper_specs: false,
      routing_specs: false,
      controller_specs: true,
      request_specs: false

      g.fixture_replacement :factory_girl
    end
    TEXT
end

# Haml setup
gem 'haml'
gem 'haml-rails'

# Zurb
gem 'zurb-foundation'

# Vagrant setup
gem_group :development, :test do
  gem 'therubyracer', platforms: :ruby
end

# Remove extraneous stuff in Gemfile; thanks AppComposer
gsub_file 'Gemfile', /#.*\n/, "\n"

# Stuff you need to do if you skip ActiveRecord,
# assuming you are using Sequel
  
if options[:skip_active_record]
  gem 'pg'
  gem 'sequel-rails'
  file 'config/database.yml', <<-TEXT
default: &default
  adapter: postgresql
  username: vagrant
  template: template0
  locale: en_US.UTF8
  encoding: unicode
TEXT

  inject_into_file "config/database.yml", \
    after: "encoding: unicode\n" do
    
      "development:\n" \
      "  <<: *default\n" \
      "  database: #{app_path}_development\n\n" \
      "test:\n" \
      "  <<: *default\n" \
      "  database: #{app_path}_test\n\n"
  end
end

run 'bundle install'

rake "db:create"

run 'rails g rspec:install'

gsub_file "spec/spec_helper.rb", /ActiveRecord::Migration/, "# ActiveRecord::Migration"
  
gsub_file "spec/spec_helper.rb",  /config.fixture_path/, "# config.fixture_path"

gsub_file "spec/spec_helper.rb", /config.use_transactional_fixtures = true/, "# config.use_transactional_fixtures = true"

inject_into_file  "spec/spec_helper.rb", \
  after: "require 'rspec/autorun'\n" do
  <<-TEXT
require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist
  TEXT
end

inject_into_file "spec/spec_helper.rb", \
  after: "config.order = \"random\"\n" do
  <<-TEXT

  # filter out "skipped" specs
  config.filter_run_excluding skip: true

  # Include Factory Girl syntax to avoid namespacing FactoryGirl calls
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  TEXT
end

unless options[:skip_active_record]
  inject_into_file "spec/spec_helper.rb", \
      after: "config.order = \"random\"\n" do
        "config.use_transactional_fixtures = false\n"
  end
end

#Zurb setup
run 'rails g foundation:install'

run 'bundle exec guard init rspec'
