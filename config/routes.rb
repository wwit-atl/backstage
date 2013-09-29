Backstage::Application.routes.draw do

  devise_for :members

  concern :notable do
    resources :notes
  end

  resources :members, :concerns => :notable
  resources :skills,  :concerns => :notable

  root 'members#dashboard'

end
