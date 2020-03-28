class CreateMemberNotifs < ActiveRecord::Migration[5.2]
  def change
    create_table :member_notifs do |t|
      t.belongs_to :member, index: true
      t.belongs_to :notifaction, index: true
      t.boolean :viewed
      t.timestamps
    end
  end
end
