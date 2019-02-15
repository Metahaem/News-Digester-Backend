Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      resources :users
      resources :websites
      resources :categories
      resources :stories
      resources :user_stories
      get 'scrape', to: 'stories#scrape_all'
      post 'user_stories/delete', to: 'user_stories#delete'
      post 'user_stories/create', to: 'user_stories#create'
      post 'signin', to: 'users#signin'
      get 'users/stories', to: 'user#stories'
    end
  end

end
