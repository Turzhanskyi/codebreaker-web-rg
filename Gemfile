# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

ruby '2.7.2'

gem 'codebreaker', git: 'https://github.com/Turzhanskyi/codebreaker-rg', branch: 'develop'
gem 'faker', '~> 2.15', '>= 2.15.1'
gem 'haml', '~> 5.1.2'
gem 'i18n', '~> 1.8', '>= 1.8.7'
gem 'rack', '~> 1.6', '>= 1.6.4'

group :development do
  gem 'overcommit', '~> 0.57.0', require: false
  gem 'pry', '~> 0.13.1', require: false
  gem 'rubocop', '~> 1.8', '>= 1.8.1', require: false
  gem 'rubocop-performance', '~> 1.9', '>= 1.9.2', require: false
  gem 'rubocop-rspec', '~> 2.1', require: false
end

group :test do
  gem 'rack-test', '~> 1.1'
  gem 'rspec', '~> 3.10'
  gem 'rspec_junit_formatter', '~> 0.4.1'
  gem 'simplecov', '~> 0.21.2', require: false
  gem 'temple', '~> 0.8.2'
end
