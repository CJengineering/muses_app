class KeyWord < ApplicationRecord
    has_many :articles, dependent: :destroy
    has_many :factiva_articles, dependent: :destroy
end
