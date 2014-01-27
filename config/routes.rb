Backstage::Application.routes.draw do

  devise_for :members

  concern :notable do
    resources :notes
  end

  concern :sortable do
    collection { post :reposition }
  end

  resources :show_templates
  resources :skills,  :concerns => [ :notable, :sortable ]
  resources :shows,   :concerns => :notable do
    collection do
      get 'schedule', to: 'shows#schedule'
      get 'create',   to: 'shows#create_shows', as: 'create'
    end
  end

  resources :members, :concerns => :notable do
    resource :conflicts, only: [] do
      get :manage
      get :get_conflicts, :as => :get
      put :set_conflicts, :as => :set
    end
  end
  get '/conflicts', to: 'conflicts#index'

  resources :configs, controller: 'konfigs', only: [ :index, :update ] do
    collection do
      patch :update_multiple
    end
  end

  get   '/shifts', to: 'shifts#index'
  patch '/shifts', to: 'shifts#update'

  get '/admin', to: 'members#admin'

  root 'members#show'

end
