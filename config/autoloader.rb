# frozen_string_literal: true

require 'bundler/setup'
require 'haml'
require 'codebreaker'
require 'yaml'
require 'i18n'

require_relative 'i18n_config'
require_relative '../app/helpers/route_helper'
require_relative '../app/helpers/render_helper'
require_relative '../app/services/validator'
require_relative '../app/controllers/registrations_controller'
require_relative '../app/controllers/games_controller'
require_relative '../app/controllers/storages_controller'
require_relative '../app/controllers/statistics_controller'
require_relative '../router'
