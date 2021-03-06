# frozen_string_literal: true

class RegistrationsController
  def create_game(request)
    user = Codebreaker::User.new(request.params['user_name'])
    raise StandardError, "Name #{request.params['user_name']} isn't valid" unless user.valid?

    user = Codebreaker::User.new(request.params['user_name'])
    difficulty = Codebreaker::Difficulty.new(request.params['level'])
    @game = Codebreaker::Game.new(user, difficulty)
  end
end
