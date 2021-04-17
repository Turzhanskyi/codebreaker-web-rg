# frozen_string_literal: true

class GamesController
  include Helpers::RouteHelper

  attr_reader :lose_state, :win_state, :game_over, :decor_render

  def initialize
    @decor_render = Helpers::RenderHelper.new
  end

  def reset_game_state
    @lose_state = false
    @win_state = false
    @game_over = nil
  end

  def won?
    win_state
  end

  def lost?
    lose_state
  end

  def error
    @input_error&.shift
  end

  def play(request)
    @game = request.session[:game]
    @user_code = request.session[:user_code]
    @hints = request.session[:hints] || []
    @game.attempts_available? ? render_page('game.html.haml') : lose_the_game(request)
  end

  def take_hint(request)
    request.session[:hints] = [] unless request.session[:hints]
    request.session[:hints] << request.session[:game].hint
  end

  def check_input(request)
    guess = Codebreaker::Guess.new(request.params['code'])
    return win_the_game(request) if win?(request) && guess.valid?

    decorate(request) if guess.valid?
    redirect_to(Router::PATH[:game])
  rescue StandardError => e
    errors = []
    @input_error = errors.push(request.params['code'] ? e.message : I18n(:guess))
  end

  private

  def lose_the_game(request)
    @lose_state = true
    finish_game(request, :lose)
  end

  def win_the_game(request)
    @win_state = true
    finish_game(request, :win)
  end

  def finish_game(request, path)
    finish(request)
    redirect_to(Router::PATH[path])
  end

  def validate_input(request)
    Codebreaker::Game.validate_input(request.params['code'])
  end

  def reset_game_session(request)
    request.session.clear
  end

  def decorate(request)
    game = request.session[:game].compare(request.params['code'])
    request.session[:user_code] = Codebreaker::Guess.decorate(game)
  end

  def win?(request)
    request.session[:game].win?(request.params['code'])
  end

  def finish(request)
    @game_over = request.session[:game]
    reset_game_session(request)
  end
end
