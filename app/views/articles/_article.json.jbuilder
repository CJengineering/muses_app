json.extract! article, :id, :key_word_id, :title, :published, :link, :posted, :created_at, :updated_at
json.url article_url(article, format: :json)
