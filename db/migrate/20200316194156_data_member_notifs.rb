class DataMemberNotifs < ActiveRecord::Migration[5.2]
  def change
  	add_column :member_notifs, :data, :jsonb, default: "{}"
  end
end
