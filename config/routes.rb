Backstage::Application.routes.draw do

  devise_for :members

  concern :notable do
    resources :notes
  end

  resources :show_templates
  resources :skills,  :concerns => :notable
  resources :shows,   :concerns => :notable

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

  get '/admin', to: 'members#admin'

  root 'members#dashboard'

end
