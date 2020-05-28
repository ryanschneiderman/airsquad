class RemoveIndexesComments < ActiveRecord::Migration[5.2]
  def change
  	remove_reference :comments, :posts, :index => true
  	remove_reference :comments, :members, :index => true
  	add_reference :comments, :member, :index => true
  	add_reference :comments, :post, :index=>true
  end
end
