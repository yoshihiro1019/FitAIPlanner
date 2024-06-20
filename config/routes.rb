Rails.application.routes.draw do
  root "static_pages#top"
  get 'boards/bookmarks', to: 'bookmarks#index', as: 'bookmarks_boards'
  resources :users, only: %i[new create]

  resources :boards do
    resources :comments, only: %i[create edit update destroy]
    resource :bookmark, only: [:create, :destroy]
  end

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end
