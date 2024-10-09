Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  root "static_pages#top"
  get 'profile/app_page', to: 'profiles#app_page', as: 'app_layout_page'
  get 'trainings/suggestions', to: 'trainings#suggestions', as: 'training_suggestions'
  get 'boards/bookmarks', to: 'bookmarks#index', as: 'bookmarks_boards'
  get 'bgm', to: 'bgms#index', as: 'bgm_selection'
  get 'gyms', to: 'gyms#index', as: 'gyms'
  # config/routes.rb
  get 'ai/generate_training_plan', to: 'ai#generate_training_plan'
  get 'training_suggestions', to: 'trainings#suggestions'
  post 'training_suggestions', to: 'trainings#generate_training_plan'
  get 'gemini_training_suggestions', to: 'trainings#gemini_suggestions'
  get 'trainings/new_training_suggestion', to: 'trainings#new_training_suggestion'
  post 'trainings', to: 'trainings#create_training_suggestion'
  resources :users, only: %i[new create]
  resources :boards do
    resources :comments, shallow: true, only: %i[create edit update destroy]
    resource :bookmark, only: [:create, :destroy]
  end  
  resource :profile, only: [:show, :edit, :update]
  resources :password_resets, only: %i[new create edit update]
  
  namespace :admin do
    root "dashboards#index"
    resources :users, only: [:index, :show, :edit, :update, :destroy]
    resources :boards
    get 'login', to: 'user_sessions#new', as: :login
    post 'login', to: 'user_sessions#create'
    delete 'logout', to: 'user_sessions#destroy', as: :logout
  end
  resources :trainings, only: [:index, :new, :create, :edit, :update, :destroy, :show]

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end
