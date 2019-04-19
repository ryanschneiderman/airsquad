class CreateTeamPlays < ActiveRecord::Migration[5.2]
  def change
    create_table :team_plays do |t|
      t.belongs_to :play
      t.belongs_to :team
      t.timestamps
    end
  end
end
