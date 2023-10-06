Rails.application.routes.draw do
  resources :posts
  resources :summaries
  resources :articleinterns
  resources :bing_articles
  resources :gosearts
  resources :media
  resources :factiva_articles
  resources :articles
  resources :key_words do
    get 'keyword_posts/:id', to: 'key_words#keyword_posts', as: 'keyword_posts'
    collection do
      post :import
    end
  end
  root 'static#home'
  devise_for :users

  get 'static/test_post'
  get 'static/test'
  get 'static/test_webflow'
  post 'static/test_webhook'
  get 'static/scraper'
  get 'static/gosearts'
  get 'static/bing_news'
  get 'static/dashboard'
  get 'static/articleintern'
  get 'static/analyzer'
  get 'static/analyzer_new'
  get 'static/keyword_list'
  get 'static/article_creator'
  # test only

  get 'static/gosearts_test'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
