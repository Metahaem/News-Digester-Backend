Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      resources :users
      resources :websites
      resources :categories
      resources :stories
      resources :user_stories
      get 'scrape', to: 'stories#scrape_all'
      post 'delete', to: 'user_stories#update_text'
    end
  end

end
