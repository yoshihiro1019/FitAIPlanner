# config/routes.rb
Rails.application.routes.draw do
  root "static_pages#top"
  resources :users, only: %i[new create]
  resources :boards do
    resources :comments, shallow: true, only: %i[create edit update destroy]
    resource :bookmark, only: %i[create destroy]
  end
  get 'bookmarks', to: 'bookmarks#index', as: 'bookmarks_boards'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end
