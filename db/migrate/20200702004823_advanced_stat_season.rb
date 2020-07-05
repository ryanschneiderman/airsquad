class AdvancedStatSeason < ActiveRecord::Migration[5.2]
  def change
  	add_reference :advanced_stats, :season, index: true
  	add_reference :lineup_adv_stats, :season, index: true
  	add_reference :lineup_game_advanced_stats, :season, index: true
  	add_reference :lineup_game_stats, :season, index: true
  	add_reference :lineup_stats, :season, index: true
  	add_reference :practice_stat_granules, :season, index: true
  	add_reference :practice_stat_totals, :season, index: true
  	add_reference :practice_stats, :season, index: true
  	add_reference :season_advanced_stats, :season, index: true
  	add_reference :season_stats, :season, index: true
  	add_reference :season_team_adv_stats, :season, index: true
  	add_reference :stat_granules, :season, index: true
  	add_reference :stat_totals, :season, index: true
  	add_reference :stats, :season, index: true
  	add_reference :team_advanced_stats, :season, index: true
  	add_reference :team_season_stats, :season, index: true
  	add_column :stat_granules, :is_opponent, :boolean
  end
end
