# frozen_string_literal: true

class RegistrationsController
  include Validator

  def create_game(request)
    user = Codebreaker::User.new(request.params['user_name'])
    validate(user, request)

    difficulty = Codebreaker::Difficulty.new(request.params['level'])
    @game = Codebreaker::Game.new(user, difficulty)
  end
end
