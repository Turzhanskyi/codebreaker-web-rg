# frozen_string_literal: true

class StatisticsController
  include Helpers::RenderHelper
  STORAGE_FILE = 'statistics.yml'

  NO_RESULTS = 'There are no winners yet! Be the first!'

  def show_stats
    storage = Codebreaker::Storage.new(STORAGE_FILE)
    winners = YAML.load_file(storage.storage_file)[:winners]
    @stats = Codebreaker::Statistics.sorted_winners(winners)

    statistics_page
  end
end
