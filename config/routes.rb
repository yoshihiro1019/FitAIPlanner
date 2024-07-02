Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  root "static_pages#top"
  
  get 'boards/bookmarks', to: 'bookmarks#index', as: 'bookmarks_boards'
  resources :users, only: %i[new create]
  resources :boards do
    resources :comments, shallow: true, only: %i[create edit update destroy]
    resource :bookmark, only: [:create, :destroy]
  end  
  resource :profile, only: [:show, :edit, :update]
  resources :password_resets, only: %i[new create edit update]
  

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end
