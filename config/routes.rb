Rails.application.routes.draw do
  resources :deliveries do
    member do
      post 'toggle'
      post 'toogle2'
    end
    collection do
      post :import
      get :indexlivraison
      get :indexday
      get :indexweek
      get :indexhistorique
    end
  end
  root 'deliveries#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
