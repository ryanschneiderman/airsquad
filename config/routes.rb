Rails.application.routes.draw do
  resources :posts
  resources :stat_lists
  resources :game_stats
  resources :games 
  
  devise_for :users, :controllers => {:registrations => "registrations"}

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'pages#index'

  get 'landing' => 'landing#index'
  get 'about'=> 'pages#about'
  get 'tutorial' => 'pages#tutorial'
  get 'product' => 'pages#product'
  get 'demos' => 'pages#demos'
  get 'demo1' => 'pages#demo1'

  get 'play_demo' => 'pages#play_demo'

  get 'add_team' => 'teams#new'

 # post '/teams/:team_id/plays/new' => "plays#new"

  post '/teams/:team_id/plays/new_play' => "plays#new_play"

  post '/teams/:team_id/plays/:play_id/soft_delete' => "plays#soft_delete"
  post '/teams/:team_id/plays/:play_id/recover' => "plays#recover"
  post '/teams/:team_id/plays/delete_all' => "plays#destroy_all"
  post '/teams/:team_id/plays/recover_all' => "plays#recover_all"
  patch '/teams/:team_id/plays/:play_id/update_name' => "plays#update_name"

  post '/teams/:team_id/playlists/:playlist/delete_association' => "playlists#delete_association"

  post '/teams/:team_id/plays/:play_id/blank_progression' => 'progressions#blank_progression'

  post '/plays/:play_id/progressions/next(.:format)' => 'progressions#create_next'

  get '/teams/:team_id/games/:id/game_mode(.:format)' => 'games#game_mode'

  get '/teams/:team_id/practices/:id/practice_mode(.:format)' => 'practices#practice_mode', as: :practice_mode

  get '/teams/:team_id/scrimmage_mode(.:format)' => 'practices#scrimmage_mode', as: :scrimmage_mode

  post '/teams/:team_id/games/:id/game_state_update(.:format)' => 'games#game_state_update'

  post '/teams/:team_id/practices/:id/scrimmage_mode_submit' => 'practices#scrimmage_mode_submit'

  post '/teams/:team_id/games/:id/game_mode(.:format)' => 'games#game_mode_submit'

  get '/teams/:team_id/members/:member_id(.:format)' => 'members#player_profile'

  post '/teams/:team_id/lineup_explorer' => "teams#create_lineup"

  post '/teams/:team_id/settings(.:format)' => "settings#update"

  get 'test_home' => 'pages#test_home'

  post '/teams/:team_id/posts/:post_id/comment(.:format)' => "posts#create_comment"

  get '/bezier' => "games#bezier" 

  post '/notifications' => "notifications#viewed"
  post '/notification_read' => "notifications#read"
  get '/notifications' => "notifications#get", as: :get_notifications
  
  post '/plays/:play_id/progressions/remove_progression_notification(.:format)' => 'progressions#remove_progression_notification'

  get 'messenger', to: 'messengers#index'
  get 'get_private_conversation', to: 'messengers#get_private_conversation'
  get 'get_group_conversation', to: 'messengers#get_group_conversation'
  get 'open_messenger', to: 'messengers#open_messenger'

  post '/teams/:team_id/join_team' => "teams#join_member"

  resources :plays do
    resources :progressions
  end 

  namespace :private do 
    resources :conversations, only: [:create] do
      member do
        post :close
        post :open
      end
    end
    resources :messages, only: [:index, :create]
  end

  namespace :group do 
    resources :conversations do
      member do
        post :close
        post :open
      end
    end
    resources :messages, only: [:index, :create]
  end

  authenticate :user do
    resources :teams do 
      resources :team_stats do 
      end
      resources :practices do 
      end
      resources :stats do
      end
      resources :games do 
      end
      resources :plays do 
        resources :progressions 
      end
      resources :posts do 
      end
      resources :members do 
      end
      resources :lineups do 
      end
      resources :settings do
      end
    end
  end

  resources :teams do 
    resources :team_stats do 
    end
    resources :stats do
    end
    resources :games do 
    end
    resources :plays do 
      resources :progressions 
    end
    resources :posts do 
    end
    resources :members do 
    end
    resources :lineups do 
    end
    resources :settings do
    end
    resources :playlists do 
    end
  end


  post 'join_team' => 'teams#join'

  devise_scope :user do
	  get 'login', to: 'devise/sessions#new'
	end

	devise_scope :user do
	  get 'signup', to: 'devise/registrations#new'
	end
  
end
