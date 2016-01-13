require 'api_constraints'

Backstage::Application.routes.draw do

  devise_for :members

  concern :notable do
    resources :notes
  end

  concern :sortable do
    collection { post :reposition }
  end

  # API Calls
  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :members do
        get :conflicts
      end

      get 'event/:id',    to: 'events#event'
      get 'events/:date', to: 'events#events'
    end
  end

  resources :announcements, controller: 'messages', :as => :messages do
    get :approve
    get :resend_email
  end

  resource :inbox, controller: 'inbox', :only => [:show,:create] # For email WebHooks

  resources :skills,  :concerns => :sortable

  resources :show_templates, except: [:show]
  resources :shows,   :concerns => :notable do
    collection do
      get 'create',   to: 'shows#create_shows', as: 'create'
    end
    post 'casting_announcement'
  end

  get '/members/schedule'
  resources :members, :concerns => :notable do
    get :cast_list
    resource :conflicts do
      get :manage_conflicts, :as => :manage
      get :get_conflicts,  :as => :get
      put :set_conflicts,  :as => :set
    end
  end
  get '/conflicts',      to: 'conflicts#index'
  put '/lock_conflicts', to: 'conflicts#lock_conflicts'
  get '/roles',          to: 'members#roles'

  resources :configs, controller: 'konfigs', only: [ :index, :update ] do
    collection do
      patch :update_multiple
    end
  end

  # Shifts
  get   '/shifts', to: 'shifts#index'
  patch '/shifts', to: 'shifts#update'
  get 'shifts/schedule'
  get 'shifts/publish'

  # Audit logs
  get '/audit',       to: 'audits#index'
  get '/audit/:type', to: 'audits#index'

  # Used for testing (inactive when in production mode)
  get '/admin', to: 'members#admin'

  root 'members#show'

end
