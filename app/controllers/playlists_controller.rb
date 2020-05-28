class PlaylistsController < ApplicationController
	def create
		team_id = params[:team_id]
		play_ids = params[:plays]
		playlist_name = params[:playlist_name]
		playlist = Playlist.create(name: playlist_name, team_id: team_id)
		playlist.color_scheme = playlist.id.modulo(7)
		playlist.save!
		progression_imgs = []
		play_ids.each do |play_id|
			play = Play.find_by_id(play_id)
			playlist_association = PlaylistAssociation.new(play: play, playlist: playlist,)
			playlist_association.save!
			progression = Progression.where(play_id: play.id)
			progression_img = progression[0].play_image
			progression_imgs.push({progression_img: url_for(progression_img), play_id: play.id, play_name: play.name})
		end
		render :json => {playlist_name: playlist_name, playlist_id: playlist.id, playlist_imgs: progression_imgs, color_scheme: playlist.color_scheme}
	end

	def update
		team_id = params[:team_id]
		play_ids = params[:plays]
		playlist_name = params[:playlist_name]
		playlist = Playlist.find_by_id(params[:playlist_id])
		if playlist_name
			playlist.update(name: playlist_name)
		end
		
		if play_ids
			play_ids.each do |play_id|
				play = Play.find_by_id(play_id)
				playlist_association = PlaylistAssociation.new(play: play, playlist: playlist)
				playlist_association.save!
			end
		end
	end

	def delete_association
		team_id = params[:team_id]
		playlist_id = params[:playlist_id]
		play_id = params[:play_id]
		PlaylistAssociation.where(play_id: play_id, playlist_id: playlist_id).take.destroy
	end

	def destroy
		playlist_id = params[:playlist_id]
		assoc = PlaylistAssociation.where(playlist_id: playlist_id).take
		if assoc
			assoc.destroy
		end
		playlist = Playlist.find_by_id(playlist_id)
		playlist.destroy
	end
end
