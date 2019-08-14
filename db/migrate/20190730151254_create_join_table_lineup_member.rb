class CreateJoinTableLineupMember < ActiveRecord::Migration[5.2]
  def change
    create_join_table :lineups, :members do |t|
       t.index [:lineup_id, :member_id]
       t.index [:member_id, :lineup_id]
    end
  end
end
