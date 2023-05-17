Rails.application.routes.draw do
  resources :media
  resources :factiva_articles
  resources :articles
  resources :key_words do
    collection do 
      post :import
    end
  end
  root 'static#home'
  devise_for :users  

  get 'static/test_post'
  get 'static/test'
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
