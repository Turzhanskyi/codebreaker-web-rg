# frozen_string_literal: true

class GamesController
  include Helpers::RenderHelper
  include Helpers::RouteHelper

  attr_reader :game_over

  def reset_game_state
    @lose_state = false
    @win_state = false
    @game_over = nil
  end

  def won?
    @win_state
  end

  def lost?
    @lose_state
  end

  def error
    @input_error&.shift
  end

  def play(request)
    @game = request.session[:game]
    @user_code = request.session[:user_code]
    @hints = request.session[:hints] || []
    @game.attempts_available? ? game_page : lose_the_game(request)
  end

  def take_hint(request)
    request.session[:hints] = [] unless request.session[:hints]
    request.session[:hints] << request.session[:game].hint
  end

  def check_input(request)
    guess = Codebreaker::Guess.new(request.params['code'])
    if guess.valid?
      return win_the_game(request) if win?(request)

      decorate(request)
    end
    back_to_active_game
  rescue StandardError => e
    @input_error = [].push(request.params['code'] ? e.message : 'Input your guess!')
  end

  private

  def lose_the_game(request)
    @game_over = request.session[:game]
    reset_game_session(request)
    @lose_state = true
    redirect_to_lose_page
  end

  def win_the_game(request)
    @game_over = request.session[:game]
    reset_game_session(request)
    @win_state = true
    redirect_to_win_page
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
end
