Rails.application.routes.draw do
  root to: 'planets#index'
  resources :characters, only: [:index]
  resources :planets, only: [:index]
end
