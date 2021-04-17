# frozen_string_literal: true

class StoragesController
  include Helpers::RouteHelper

  STORAGE_FILE = 'statistics.yml'

  attr_reader :decor_render

  def initialize
    @decor_render = Helpers::RenderHelper.new
  end

  def win(current_game)
    @game_over = current_game.game_over
    save if @game_over
    current_game.won? ? render_page('win.html.haml') : redirect_to(Router::PATH[:home])
  end

  def lose(current_game)
    @game_over = current_game.game_over
    current_game.lost? ? render_page('lose.html.haml') : redirect_to(Router::PATH[:home])
  end

  private

  def save_storage
    @yml_store.transaction { @yml_store[:winners] = @winners || [] }
  end

  def synchronize_storage
    @yml_store.transaction(true) { @winners = @yml_store[:winners] }
  end

  def save
    @storage = Codebreaker::Storage.new(STORAGE_FILE)
    @yml_store = @storage.new_store
    save_storage unless @storage.storage_exists?
    synchronize_storage
    @winners << @game_over
    save_storage
  end
end
