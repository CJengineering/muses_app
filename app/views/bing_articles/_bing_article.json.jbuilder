json.extract! bing_article, :id, :key_word_id, :title, :category_label, :score, :score_second, :published, :link, :created_at, :updated_at
json.url bing_article_url(bing_article, format: :json)
