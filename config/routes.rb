Rails.application.routes.draw do
  devise_for :users

  get 'languages/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'collections#show'

  resources :languages
  resources :scripts
  resources :collections
  resources :articles

  get '/pairs', to: 'collections#pairs', as: 'pairs'

  get  'upload_dialog', to: 'collections#upload_dialog'
  post 'upload_languages', to: 'collections#upload_languages'
  post 'upload_articles', to: 'collections#upload_articles'
end
