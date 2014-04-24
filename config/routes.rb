Backstage::Application.routes.draw do

  devise_for :members

  concern :notable do
    resources :notes
  end

  concern :sortable do
    collection { post :reposition }
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

  get   '/shifts', to: 'shifts#index'
  patch '/shifts', to: 'shifts#update'
  get 'shifts/schedule'
  get 'shifts/publish'

  # Used for testing (inactive when in production mode)
  get '/admin', to: 'members#admin'

  root 'members#show'

end
