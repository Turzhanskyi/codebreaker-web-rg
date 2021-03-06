# frozen_string_literal: true

require 'bundler/setup'
require 'haml'
require 'codebreaker'
require 'yaml'
require 'erb'

require_relative '../app/helpers/render_helper'
require_relative '../app/helpers/route_helper'
require_relative '../app/controllers/registrations_controller'
require_relative '../app/controllers/storages_controller'
require_relative '../app/controllers/games_controller'
require_relative '../app/controllers/statistics_controller'
require_relative '../router'
