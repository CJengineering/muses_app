class BingArticle < ApplicationRecord
  belongs_to :key_word
  validates :link, uniqueness: true
end
