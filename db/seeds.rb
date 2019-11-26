# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def seed_users
  user_id = 0
  team1_players = ["Peyton", "Kyle", "Jack R", "Jack S", "Ethan M", "Ethan R", "Wyatt", "Brady", "Colby", "Eddie", "Russell", "Oliver", "Logan"]
  team2_players = ["Zack", "Ed", "Lucas", "Ryan", "Brandon", "Matt H", "Matt C", "Chris", "Jed", "Drew", "Hans", "Gabe", "Brad"]
  26.times do 
    if user_id % 2 == 0 
      User.create(
        name: "#{team1_players[user_id / 2]}",
        email: "#{team1_players[user_id / 2]}@test.com",
        password: '123456',
        password_confirmation: '123456'
      )
    else
      User.create(
        name: "#{team2_players[user_id / 2]}",
        email: "#{team2_players[user_id / 2]}@test.com",
        password: '123456',
        password_confirmation: '123456'
      )
    end
    user_id = user_id + 1
  end
end

def seed_team
	team_id = 1
  2.times do 
    Team.create(
      name: "team#{team_id}",
      username: "test#{team_id}",
      password: "pass#{team_id}"
    )
   team_id = team_id + 1
  end
end

def seed_players
  users = User.first(26)  
  team1 = Team.first
  team2 = Team.last
  team1_players = ["Peyton", "Kyle", "Jack R", "Jack S", "Ethan M", "Ethan R", "Wyatt", "Brady", "Colby", "Eddie", "Russell", "Oliver", "Logan"]
  team2_players = ["Zack", "Ed", "Lucas", "Ryan", "Brandon", "Matt H", "Matt C", "Chris", "Jed", "Drew", "Hans", "Gabe", "Brad"]
  team1_name_id = 0;
  team2_name_id = 0;
  iterator = 0;

  users.each do |user|
  	if iterator % 2 == 0
	    Member.create(
	      nickname: "#{team1_players[team1_name_id]}",
        isPlayer: true,
	      user_id: user.id, 
	      team_id: team1.id
	    )
    	team1_name_id = team1_name_id + 1
    else 
    	Member.create(
	      nickname: "#{team2_players[team2_name_id]}",
        isPlayer: true,
	      user_id: user.id, 
	      team_id: team2.id
	    )
    	team2_name_id = team2_name_id + 1 
    end
    iterator = iterator + 1	  
  end
end  

def seed_coaches
	users = User.last(2)
  team1 = Team.first
  team2 = Team.last

  Member.create(
  		nickname: "Ryan",
      isAdmin: true,
      user_id: users[0].id, 
      team_id: team1.id
  )
  Member.create(
  		nickname: "Mike",
      isAdmin: true,
      user_id: users[1].id, 
      team_id: team2.id
  )
end

seed_users
seed_team
seed_players
seed_coaches
