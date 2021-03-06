# frozen_string_literal: true

RSpec.describe StoragesController do
  include Rack::Test::Methods
  include Helpers::RenderHelper

  let(:finish_game) { described_class.new }
  let(:current_game) { GamesController.new }
  let(:game) { Codebreaker::Game.new(Codebreaker::User.new('User'), Codebreaker::Difficulty.new('hell')) }

  before do
    current_game.instance_variable_set(:@game_over, game)
  end

  describe '#lose' do
    it 'redirects to lose page when game is lost' do
      allow(current_game).to receive(:lost?).and_return(true)
      expect(finish_game).to receive(:lose_page)
      finish_game.lose(current_game)
    end

    it 'redirects to home_page when game is not lost' do
      allow(current_game).to receive(:lost?).and_return(false)
      expect(finish_game).to receive(:back_home)
      finish_game.lose(current_game)
    end
  end

  describe '#win' do
    before { stub_const('StatisticsController::STORAGE_FILE', 'statistics.yml') }

    it 'redirects to win page when game is won' do
      allow(current_game).to receive(:won?).and_return(true)
      expect(finish_game).to receive(:win_page)
      finish_game.win(current_game)
    end

    it 'redirects to home page when game is not won' do
      allow(current_game).to receive(:won?).and_return(false)
      expect(finish_game).to receive(:back_home)
      finish_game.lose(current_game)
    end
  end
end
