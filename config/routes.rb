Rails.application.routes.draw do
  root 'application#dashboard'
  resources :apps, only: [:index, :show] do
    resources :signals, only: [:index, :show, :create], shallow: true
  end
  
  resources :errors, only: [:index]
end
