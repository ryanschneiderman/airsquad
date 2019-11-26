class Stats::RenameStatListsService
	def initialize()
	end

	def call 
		make = StatList.find_by_id(1)
		make.update_attribute(:stat, "Field Goals")

		miss = StatList.find_by_id(2)
		miss.update_attribute(:stat, "Field Goal Misses")

		assist = StatList.find_by_id(3)
		assist.update_attribute(:stat, "Assists")

		oreb = StatList.find_by_id(4)
		oreb.update_attribute(:stat, "Offensive Rebounds")

		dreb = StatList.find_by_id(5)
		dreb.update_attribute(:stat, "Defensive Rebounds")

		stls = StatList.find_by_id(6)
		stls.update_attribute(:stat, "Steals")

		tov = StatList.find_by_id(7)
		tov.update_attribute(:stat, "Turnovers")

		blk = StatList.find_by_id(8)
		blk.update_attribute(:stat, "Blocks")

		two_ptm = StatList.find_by_id(9)
		two_ptm.update_attribute(:stat, "2 Point Field Goals")

		three_ptm = StatList.find_by_id(10)
		three_ptm.update_attribute(:stat, "2 Point Misses")

		three_ptm = StatList.find_by_id(11)
		three_ptm.update_attribute(:stat, "3 Point Field Goals")

		three_ptm = StatList.find_by_id(12)
		three_ptm.update_attribute(:stat, "3 Point Misses")

		fouls = StatList.find_by_id(17)
		fouls.update_attribute(:stat, "Fouls")

		ft_makes = StatList.find_by_id(13)
		ft_makes.update_attribute(:stat, "Free Throw Makes")

		ft_misses = StatList.find_by_id(14)
		ft_misses.update_attribute(:stat, "Free Throw Misses")

	end
end