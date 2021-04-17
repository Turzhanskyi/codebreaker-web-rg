# frozen_string_literal: true

class Router
  include Helpers::RouteHelper
  PATH = { home: '/',
           game: '/game',
           rules: '/rules',
           statistics: '/statistics',
           take_hint: '/take_hint',
           submit_answer: '/submit_answer',
           lose: '/lose',
           win: '/win' }.freeze

  VIEWS = '../../views/'

  def initialize
    @register_game = RegistrationsController.new
    @current_game = GamesController.new
    @storage = StoragesController.new
    @statistic = StatisticsController.new
  end

  def call(env)
    @request = Rack::Request.new(env)
    PATH.value?(@request.path) ? method(PATH.key(@request.path)).call : render_page('not_found.html.haml', 404)
  end

  def error
    @registration_error&.shift
  end

  private

  def rules
    return redirect_to(PATH[:game]) if active_game?

    render_page('rules.html.haml')
  end

  def home
    @request.session.clear
    return redirect_to(PATH[:game]) if active_game?

    @current_game.reset_game_state
    render_page('menu.html.haml')
  end

  def statistics
    return redirect_to(PATH[:game]) if active_game?

    @statistic.show_stats
  end

  def active_game?
    @request.session[:game]
  end

  def game
    return redirect_to(PATH[:home]) if @request.get? && !active_game?

    @request.session[:game] ||= @register_game.create_game(@request)
    @current_game.play(@request)
  rescue StandardError => e
    @registration_error = [] << e.message
    redirect_to(PATH[:home])
  end

  def take_hint
    if active_game?
      @current_game.take_hint(@request)
      redirect_to(PATH[:game])
    else
      redirect_to(PATH[:home])
    end
  rescue StandardError => _e
    redirect_to(PATH[:game])
  end

  def submit_answer
    return redirect_to(PATH[:home]) unless active_game?

    @current_game.check_input(@request)
  end

  def win
    return redirect_to(PATH[:game]) if active_game?

    @storage.win(@current_game)
  end

  def lose
    return redirect_to(PATH[:game]) if active_game?

    @storage.lose(@current_game)
  end
end
