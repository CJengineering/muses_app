json.extract! post, :id, :key_word_id, :title, :published, :link, :category_label, :score, :score_second, :source, :created_at, :updated_at
json.url post_url(post, format: :json)
