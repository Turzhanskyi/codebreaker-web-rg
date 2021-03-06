# frozen_string_literal: true

RSpec.describe RegistrationsController do
  include Rack::Test::Methods
  def app
    Rack::Builder.parse_file('config.ru').first
  end

  let(:user) { described_class.new }

  describe '#create_game' do
    context 'when input is valid' do
      it 'creates game instance' do
        post '/game'
        last_request.instance_variable_set(:@params, { 'user_name' => 'User', 'level' => 'hell' })
        expect(user.create_game(last_request).class).to eq(Codebreaker::Game)
      end
    end
  end
end
