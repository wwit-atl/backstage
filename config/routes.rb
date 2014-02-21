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

  resources :show_templates, except: [:show]
  resources :skills,  :concerns => :sortable
  resources :shows,   :concerns => :notable do
    collection do
      get 'schedule', to: 'shows#schedule'
      get 'create',   to: 'shows#create_shows', as: 'create'
    end
    post 'casting_announcement'
  end

  resources :members, :concerns => :notable do
    resource :conflicts do
      get :manage
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

  # Used for testing (inactive when in production mode)
  get '/admin', to: 'members#admin'

  root 'members#show'

end
