class PracticeStatGranule < ApplicationRecord
	belongs_to :member,  optional: true
	belongs_to :practice
	belongs_to :stat_list
	belongs_to :season
end
