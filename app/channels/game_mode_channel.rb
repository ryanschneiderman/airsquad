class GameModeChannel < ApplicationCable::Channel
  def subscribed
  	stream_from "game_mode_channel_#{params[:game_id]}"
  end

  def receive(data)
  	if data["new_stat"]
  		ActionCable.server.broadcast("game_mode_channel_#{params[:game_id]}", {new_stat: data["new_stat"], sent_by: data["sent_by"], lineups_arr: data["game_state"]["lineups_arr"]})
  		game = Game.find(params[:game_id])
	  	game.update_attributes(:game_state => data["game_state"])
	  	game.save
    elsif data["undo_stat"]
      ActionCable.server.broadcast("game_mode_channel_#{params[:game_id]}", {undo_stat: data["undo_stat"], sent_by: data["sent_by"], lineups_arr: data["game_state"]["lineups_arr"]})
      game = Game.find(params[:game_id])
      game.update_attributes(:game_state => data["game_state"])
      game.save
  	elsif data["clock_load"]
  		ActionCable.server.broadcast("game_mode_channel_#{params[:game_id]}", {sent_by: data["sent_by"], load_clock: data["clock_load"]})
  	elsif data["clock_update"]
  		ActionCable.server.broadcast("game_mode_channel_#{params[:game_id]}", {sent_by: data["sent_by"], clock_update: data["game_state"]["clock"]})
  		game = Game.find(params[:game_id])
	  	game.update_attributes(:game_state => data["game_state"])
	  	game.save
  	elsif data["trigger_update"]
  		ActionCable.server.broadcast("game_mode_channel_#{params[:game_id]}", {trigger_update: true})
  	elsif data["lineup_data"]
  		ActionCable.server.broadcast("game_mode_channel_#{params[:game_id]}", {lineup_data: data["lineup_data"], lineups_arr: data["game_state"]["lineups_arr"]})
  		game = Game.find(params[:game_id])
	  	game.update_attributes(:game_state => data["game_state"])
	  	game.save
  	else
	  	game = Game.find(params[:game_id])
	  	game.update_attributes(:game_state => data["game_state"])
	  	game.save
	end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
