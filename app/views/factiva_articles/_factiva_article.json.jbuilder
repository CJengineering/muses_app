json.extract! factiva_article, :id, :title, :description, :factiva_link, :published, :posted, :url_g_1, :url_g_2, :created_at, :updated_at
json.url factiva_article_url(factiva_article, format: :json)
