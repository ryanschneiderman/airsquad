class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
    	t.string :title
    	t.text :content
    	t.belongs_to :team, index: true
    	t.belongs_to :member, index: true
      t.timestamps
    end
  end
end
