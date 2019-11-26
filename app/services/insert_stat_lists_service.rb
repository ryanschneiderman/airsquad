class InsertStatListsService
	def initialize()
	end

	def call()
		puts "********************INSERTING STAT LISTS*******************"
		StatList.create(
			stat: "Field Goals",
			default_stat: true,
			collectable: true,
			team_stat: false,
			display_priority: 1,
			advanced: false,
			rankable: true,
			is_percent: false,
			stat_kind: 1
		)
		##  t            | t           | f         |                1 | f        | f        | f          |         1
		StatList.create(
			stat: "Field Goal Misses",
			default_stat: true,
			collectable: true,
			team_stat: false,
			display_priority: 1,
			advanced: false,
			rankable: false,
			is_percent: false,
			stat_kind: 1
		)
		## f            | t           | f         |                9 | f        | t        | f          |         1
		StatList.create(
			stat: "Assists",
			default_stat: false,
			collectable: true,
			team_stat: false,
			display_priority: 9,
			advanced: false,
			rankable: true,
			is_percent: false,
			stat_kind: 1
		)
		## f            | t           | f         |               10 | f        | t        | f          |         2
		StatList.create(
			stat: "Offensive Rebounds",
			default_stat: false,
			collectable: true,
			team_stat: false,
			display_priority: 10,
			advanced: false,
			rankable: true,
			is_percent: false,
			stat_kind: 2
		)
		## f            | t           | f         |               11 | f        | t        | f          |         2
		StatList.create(
			stat: "Defensive Rebounds",
			default_stat: false,
			collectable: true,
			team_stat: false,
			display_priority: 11,
			advanced: false,
			rankable: true,
			is_percent: false,
			stat_kind: 2
		)
		## f            | t           | f         |               12 | f        | t        | f          |         2
		StatList.create(
			stat: "Steals",
			default_stat: false,
			collectable: true,
			team_stat: false,
			display_priority: 12,
			advanced: false,
			rankable: true,
			is_percent: false,
			stat_kind: 2
		)
		## f            | t           | f         |               14 | f        | t        | f          |         1
		StatList.create(
			stat: "Turnovers",
			default_stat: false,
			collectable: true,
			team_stat: false,
			display_priority: 14,
			advanced: false,
			rankable: true,
			is_percent: false,
			stat_kind: 1
		)
		## Blocks                              | f            | t           | f         |               13 | f        | t        | f          |         2
		StatList.create(
			stat: "Blocks",
			default_stat: false,
			collectable: true,
			team_stat: false,
			display_priority: 13,
			advanced: false,
			rankable: true,
			is_percent: false,
			stat_kind: 2
		)
		## 2 Point Field Goals                 | t            | f           | f         |                  | f        | f        | f          |         1
		StatList.create(
			stat: "2 Point Field Goals",
			default_stat: true,
			collectable: false,
			team_stat: false,
			advanced: false,
			rankable: false,
			is_percent: false,
			stat_kind: 1
		)
		## 2 Point Misses                      | t            | f           | f         |                  | f        | f        | f          |         1
		StatList.create(
			stat: "2 Point Misses",
			default_stat: true,
			collectable: false,
			team_stat: false,
			advanced: false,
			rankable: false,
			is_percent: false,
			stat_kind: 1
		)
		## 3 Point Field Goals                 | t            | f           | f         |                5 | f        | t        | f          |         1
		StatList.create(
			stat: "3 Point Field Goals",
			default_stat: true,
			collectable: false,
			team_stat: false,
			display_priority: 5,
			advanced: false,
			rankable: true,
			is_percent: false,
			stat_kind: 1
		)
		## | t            | f           | f         |                5 | f        | f        | f          |         1
		StatList.create(
			stat: "3 Point Misses",
			default_stat: true,
			collectable: false,
			team_stat: false,
			display_priority: 5,
			advanced: false,
			rankable: false,
			is_percent: false,
			stat_kind: 1
		)

		######################################

		##  t            | t           | f         |                7 | f        | t        | f          |         1
		StatList.create(
			stat: "Free Throw Makes",
			default_stat: true,
			collectable: true,
			team_stat: false,
			display_priority: 7,
			advanced: false,
			rankable: true,
			is_percent: false,
			stat_kind: 1
		)
		## t            | t           | f         |                7 | f        | f        | f          |         1
		StatList.create(
			stat: "Free Throw Misses",
			default_stat: true,
			collectable: true,
			team_stat: false,
			display_priority: 5,
			advanced: false,
			rankable: false,
			is_percent: false,
			stat_kind: 1
		)

		##  t            | f           | f         |               15 | f        | t        | f          |         1
		StatList.create(
			stat: "Points",
			default_stat: true,
			collectable: false,
			team_stat: false,
			display_priority: 15,
			advanced: false,
			rankable: true,
			is_percent: false,
			stat_kind: 1
		)
		##  t            | f           | f         |               17 | f        | f        | f          |         3
		StatList.create(
			stat: "Minutes",
			default_stat: true,
			collectable: false,
			team_stat: false,
			display_priority: 17,
			advanced: false,
			rankable: false,
			is_percent: false,
			stat_kind: 3
		)

		##  t            | t           | f         |               16 | f        | t        | f          |         2
		StatList.create(
			stat: "Fouls",
			default_stat: true,
			collectable: true,
			team_stat: false,
			display_priority: 16,
			advanced: false,
			rankable: true,
			is_percent: false,
			stat_kind: 2
		)
		# **********************************************************************
		# **************************** DESCRIPTIONS!!!!!! **********************
		# **********************************************************************

		##  t            | f           | f         |                1 | t        | t        | t          |         1
		StatList.create(
			stat: "Effective field goal %",
			default_stat: true,
			collectable: false,
			team_stat: false,
			display_priority: 1,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 1
		)

		##True shooting %                     | t            | f           | f         |                2 | t        | t        | t          |         1

		StatList.create(
			stat: "True shooting %  ",
			default_stat: true,
			collectable: false,
			team_stat: false,
			display_priority: 2,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 1
		)

		##Linear Player Efficiency Rating     | f            | f           | f         |               16 | t        | t        | t          |         3
		StatList.create(
			stat: "Linear Player Efficiency Rating",
			default_stat: false,
			collectable: false,
			team_stat: false,
			display_priority: 16,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 3
		)

		## 3 point attempt rate                | t            | f           | f         |                3 | t        | t        | t          |         1
		StatList.create(
			stat: "3 point attempt rate ",
			default_stat: true,
			collectable: false,
			team_stat: false,
			display_priority: 3,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 1
		)

		## Free throw attempt rate             | t            | f           | f         |                4 | t        | t        | t          |         1
		StatList.create(
			stat: "Free throw attempt rate",
			default_stat: true,
			collectable: false,
			team_stat: false,
			display_priority: 4,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 1
		)

		## Usage rate                          | f            | f           | f         |               12 | t        | t        | t          |         1
		StatList.create(
			stat: "Usage rate",
			default_stat: false,
			collectable: false,
			team_stat: false,
			display_priority: 12,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 1
		)

		## Offensive rating                    | f            | f           | f         |               13 | t        | t        | t          |         1
		StatList.create(
			stat: "Offensive rating",
			default_stat: false,
			collectable: false,
			team_stat: false,
			display_priority: 13,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 1
		)

		## Defensive rating                    | f            | f           | f         |               14 | t        | t        | t          |         2
		StatList.create(
			stat: "Defensive rating",
			default_stat: false,
			collectable: false,
			team_stat: false,
			display_priority: 14,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 2
		)

		## Net rating                          | f            | f           | f         |               15 | t        | t        | t          |         3
		StatList.create(
			stat: "Net rating",
			default_stat: false,
			collectable: false,
			team_stat: false,
			display_priority: 15,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 3
		)

		## Field goal %                        | t            | f           | f         |                2 | f        | t        | t          |         1
		StatList.create(
			stat: "Field goal %",
			default_stat: true,
			collectable: false,
			team_stat: false,
			display_priority: 2,
			advanced: false,
			rankable: true,
			is_percent: true,
			stat_kind: 1
		)

		## 3 point %                           | t            | f           | f         |                6 | f        | t        | t          |         1
		StatList.create(
			stat: "3 point %",
			default_stat: true,
			collectable: false,
			team_stat: false,
			display_priority: 6,
			advanced: false,
			rankable: true,
			is_percent: true,
			stat_kind: 1
		)

		## Free throw %                        | t            | f           | f         |                8 | f        | t        | t          |         1
		StatList.create(
			stat: "Free throw %",
			default_stat: true,
			collectable: false,
			team_stat: false,
			display_priority: 8,
			advanced: false,
			rankable: true,
			is_percent: true,
			stat_kind: 1
		)

		######################################

		##  Offensive efficiency                | f            | f           | t         |                  | t        |          |            |         1
		StatList.create(
			stat: "Offensive efficiency",
			default_stat: false,
			collectable: false,
			team_stat: true,
			advanced: true,
			stat_kind: 1
		)
		
		## Defensive efficiency                | f            | f           | t         |                  | t        |          |            |         2
		StatList.create(
			stat: "Defensive efficiency",
			default_stat: false,
			collectable: false,
			team_stat: true,
			advanced: true,
			stat_kind: 2
		)
		
		## 2 point %                           | t            | f           | f         |                4 |          |          |            |         1
		StatList.create(
			stat: "2 point %",
			default_stat: true,
			collectable: false,
			team_stat: false,
			display_priority: 4,
			stat_kind: 1,
			advanced: false,
		)
		
		## Offensive Rebound %                 | f            | f           | f         |                7 | t        | t        | t          |         2
		StatList.create(
			stat: "Offensive Rebound %",
			default_stat: false,
			collectable: false,
			team_stat: false,
			display_priority: 7,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 2
		)
		
		## Defensive Rebound %                 | f            | f           | f         |                8 | t        | t        | t          |         2
		StatList.create(
			stat: "Defensive Rebound % ",
			default_stat: false,
			collectable: false,
			team_stat: false,
			display_priority: 8,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 2
		)
		
		## Total Rebound %                     | f            | f           | f         |                9 | t        | t        | t          |         2
		StatList.create(
			stat: "Total Rebound %",
			default_stat: false,
			collectable: false,
			team_stat: false,
			display_priority: 9,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 2
		)
		
		## Steal %                             | f            | f           | f         |               10 | t        | t        | t          |         2
		StatList.create(
			stat: "Steal %",
			default_stat: false,
			collectable: false,
			team_stat: false,
			display_priority: 10,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 2
		)
		
		## Block %                             | f            | f           | f         |               11 | t        | t        | t          |         2
		StatList.create(
			stat: "Block %",
			default_stat: false,
			collectable: false,
			team_stat: false,
			display_priority: 11,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 2
		)
		
		##  Turnover %                          | f            | f           | f         |                6 | t        | t        | t          |         1
		StatList.create(
			stat: "Turnover %",
			default_stat: false,
			collectable: false,
			team_stat: false,
			display_priority: 6,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 1
		)
		
		## Assist %                            | f            | f           | f         |                5 | t        | t        | t          |         1
		StatList.create(
			stat: "Assist %",
			default_stat: false,
			collectable: false,
			team_stat: false,
			display_priority: 5,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 1
		)
		
		## Offensive Box Plus Minus            | f            | f           | f         |               20 | t        | t        | t          |         1
		StatList.create(
			stat: "Offensive Box Plus Minus",
			default_stat: false,
			collectable: false,
			team_stat: false,
			display_priority: 20,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 1
		)

		## Defensive Box Plus Minus            | f            | f           | f         |               19 | t        | t        | t          |         2
		StatList.create(
			stat: "Defensive Box Plus Minus",
			default_stat: false,
			collectable: false,
			team_stat: false,
			display_priority: 19,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 2
		)

		###########################################

		## Box Plus Minus                      | f            | f           | f         |               21 | t        | t        | t          |         3
		StatList.create(
			stat: "Box Plus Minus",
			default_stat: false,
			collectable: false,
			team_stat: false,
			display_priority: 21,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 3
		)

		## Possessions                         | f            | f           | t         |                  | t        |          |            |         1
		StatList.create(
			stat: "Possessions",
			default_stat: false,
			collectable: false,
			team_stat: true,
			advanced: true,
			stat_kind: 1
		)

		##  Unadjusted Box Plus Minus           | f            | f           | f         |               18 | t        | t        | t          |         3
		StatList.create(
			stat: "Unadjusted Box Plus Minus",
			default_stat: false,
			collectable: false,
			team_stat: false,
			display_priority: 18,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 3
		)

		## Unadjusted Offensive Box Plus Minus | f            | f           | f         |               17 | t        | t        | t          |         1
		StatList.create(
			stat: "Unadjusted Offensive Box Plus Minus",
			default_stat: false,
			collectable: false,
			team_stat: false,
			display_priority: 17,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 1
		)

		## Pace                                | f            | f           | t         |                  | t        |          |            |         3
		StatList.create(
			stat: "Pace",
			default_stat: false,
			collectable: false,
			team_stat: true,
			advanced: true,
			stat_kind: 3
		)

		##FT rate                             | f            | f           | f         |                  | t        | t        | t          |         1
		StatList.create(
			stat: "FT rate",
			default_stat: true,
			collectable: false,
			team_stat: true,
			advanced: true,
			rankable: true,
			is_percent: true,
			stat_kind: 1,
		)

		## Field goal attempts                 | t            | f           | f         |                  | f        | t        |            |         1
		StatList.create(
			stat: "Field goal attempts",
			default_stat: true,
			collectable: false,
			team_stat: false,
			advanced: false,
			rankable: true,
			is_percent: false,
			stat_kind: 1
		)

		## 3 point attempts                    | t            | f           | f         |                  | f        | t        |            |         1
		StatList.create(
			stat: "3 point attempts",
			default_stat: true,
			collectable: false,
			team_stat: false,
			advanced: false,
			rankable: true,
			stat_kind: 1
		)

		##  Free throw attempts                 | t            | f           | f         |                  | f        | t        |            |         1
		StatList.create(
			stat: "Free throw attempts",
			default_stat: true,
			collectable: false,
			team_stat: false,
			advanced: false,
			rankable: true,
			stat_kind: 1
		)


	end
end