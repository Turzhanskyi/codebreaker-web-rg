# frozen_string_literal: true

require_relative 'config/autoloader'

use Rack::Reloader
use Rack::Static, urls: ['/app/assets']
use Rack::Static, urls: %w[/bootstrap /jquery], root: 'node_modules'
use Rack::Session::Cookie, key: 'rack.session',
                           path: '/',
                           expire_after: 2_592_000,
                           secret: 'codebreaker_0803',
                           old_secret: 'codebreaker'
run Router.new
