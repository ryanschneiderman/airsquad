class MemberSeasons < ActiveRecord::Migration[5.2]
  def change
  	add_reference :members, :season, index: true
  end
end
