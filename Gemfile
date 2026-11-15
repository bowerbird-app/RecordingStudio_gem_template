# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in gem_template.gemspec
gemspec

# Neither gem is published to RubyGems. Core 7 depends on flat_pack.
gem "flat_pack", github: "bowerbird-app/flatpack", tag: "v0.1.376"
gem "recording_studio", github: "bowerbird-app/RecordingStudio", tag: "v7.0.0"

gem "devise"
gem "puma"
gem "sprockets-rails"

group :development, :test do
  gem "debug"
  gem "minitest-mock"
  gem "simplecov", require: false
end

group :development do
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
end
