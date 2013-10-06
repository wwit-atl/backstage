Backstage::Application.routes.draw do

  devise_for :members

  concern :notable do
    resources :notes
  end

  resources :members, :concerns => :notable
  resources :skills,  :concerns => :notable
  resources :shows,   :concerns => :notable
  resources :show_templates

  resources :configs, controller: 'konfigs', only: [ :index, :update ] do
    collection do
      patch :update_multiple
    end
  end

  get '/admin', to: 'members#admin'

  root 'members#dashboard'

end
