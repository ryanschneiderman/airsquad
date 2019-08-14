Rails.application.routes.draw do
  resources :posts
  resources :stat_lists
  resources :game_stats
  resources :games 
  
  devise_for :users, :controllers => {:registrations => "registrations"}

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'pages#index'

  get 'landing' => 'landing#index'

  get 'add_team' => 'teams#new'

  post '/plays/:play_id/progressions/next(.:format)' => 'progressions#create_next'

  get '/teams/:team_id/games/:id/game_mode(.:format)' => 'games#game_mode'

  post '/teams/:team_id/games/:id/game_mode(.:format)' => 'games#game_mode_submit'

  get '/teams/:team_id/members/:member_id(.:format)' => 'members#player_profile'

  post '/teams/:team_id/lineup_explorer' => "teams#create_lineup"

  get 'messenger', to: 'messengers#index'
  get 'get_private_conversation', to: 'messengers#get_private_conversation'
  get 'get_group_conversation', to: 'messengers#get_group_conversation'
  get 'open_messenger', to: 'messengers#open_messenger'

  resources :teams, :members

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
  end


  get 'join_team' => 'teams#join'

  devise_scope :user do
	  get 'login', to: 'devise/sessions#new'
	end

	devise_scope :user do
	  get 'signup', to: 'devise/registrations#new'
	end
  
end
