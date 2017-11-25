Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  resources :deliveries do
    member do
      post 'toggle'
      post 'toggle2'
    end
    collection do
      post :import
      get :indexlivraison
      get :indexday
      get :indexweek
      get :indexhistorique
      get :edit_password
    end
  end
  root 'deliveries#index'
  # API request
  mount Request::OlvoApi => '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
