Backstage::Application.routes.draw do

  devise_for :members

  concern :notable do
    resources :notes
  end

  resources :members, :concerns => :notable do
    resource :conflicts do
      get :manage
      get :get_conflicts, :as => :get
      get :set_conflicts, :as => :set
    end
  end

  resources :skills,  :concerns => :notable
  resources :shows,   :concerns => :notable
  resources :show_templates

  #resources :conflicts, only: [ :index, :edit, :update ] do
  #  collection do
  #    get :manage, :to => :edit
  #    post :manage, :to => :get_conflicts
  #    get :get_conflicts, :as => :get
  #  end
  #end

  resources :configs, controller: 'konfigs', only: [ :index, :update ] do
    collection do
      patch :update_multiple
    end
  end

  get '/admin', to: 'members#admin'

  root 'members#dashboard'

end
