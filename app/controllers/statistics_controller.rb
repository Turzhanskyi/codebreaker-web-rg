# frozen_string_literal: true

class StatisticsController
  include Helpers::RouteHelper

  attr_reader :decor_render

  def initialize
    @decor_render = Helpers::RenderHelper.new
  end

  def show_stats
    if FileTest.file?(StoragesController::STORAGE_FILE)
      winners = YAML.load_file(StoragesController::STORAGE_FILE)[:winners]
      @stats = Codebreaker::Statistics.sorted_winners(winners)
    end

    render_page('statistics.html.haml')
  end
end
