# DB setup
gem 'pg'

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

# Vagrant setup
gem_group :development, :test do
  gem 'therubyracer', platforms: :ruby
end

# Remove extraneous stuff in Gemfile; thanks AppComposer
gsub_file 'Gemfile', /\n^\s*\n/, "\n"
gsub_file 'Gemfile', /#.*\n/, "\n"

run 'bundle install'

run 'rails g rspec:install'

inject_into_file "spec/spec_helper.rb", \
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

  # Database Cleaner config
  config.use_transactional_fixtures = false

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

run 'bundle exec guard init rspec'
