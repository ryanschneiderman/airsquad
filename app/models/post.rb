class Post < ApplicationRecord
	belongs_to :member
	belongs_to :team
	belongs_to :post_type, :polymorphic => true, optional: true
	has_many :comments
end
