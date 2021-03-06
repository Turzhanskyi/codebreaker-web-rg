# frozen_string_literal: true

class Router
  include Helpers::RenderHelper
  include Helpers::RouteHelper

  def initialize
    @pathes = { '/': method(:home), '/rules': method(:rules), '/statistics': method(:statistics),
                '/game': method(:game), '/take_hint': method(:take_hint),
                '/submit_answer': method(:submit_answer), '/lose': method(:lose), '/win': method(:win) }
    @registrations_controller = RegistrationsController.new
    @games_controller = GamesController.new
    @storages_controller = StoragesController.new
    @statistics_controller = StatisticsController.new
  end

  def call(env)
    @request = Rack::Request.new(env)
    @pathes.key?(@request.path.to_sym) ? @pathes[@request.path.to_sym].call : wrong_path
  end

  def error
    @registration_error&.shift
  end

  private

  def rules
    return back_to_active_game if active_game?

    rules_page
  end

  def home
    @request.session.clear
    return back_to_active_game if active_game?

    @games_controller.reset_game_state
    home_page
  end

  def statistics
    return back_to_active_game if active_game?

    @statistics_controller.show_stats
  end

  def active_game?
    @request.session[:game]
  end

  def game
    return back_home if @request.get? && !active_game?

    @request.session[:game] ||= @registrations_controller.create_game(@request)
    @games_controller.play(@request)
  rescue StandardError => e
    @registration_error = [] << e.message
    back_home
  end

  def take_hint
    if active_game?
      @games_controller.take_hint(@request)
      back_to_active_game
    else
      back_home
    end
  rescue StandardError => _e
    back_to_active_game
  end

  def submit_answer
    return back_home unless active_game?

    @games_controller.check_input(@request)
  end

  def win
    return back_to_active_game if active_game?

    @storages_controller.win(@games_controller)
  end

  def lose
    return back_to_active_game if active_game?

    @storages_controller.lose(@games_controller)
  end
end
