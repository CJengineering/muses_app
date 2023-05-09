class Article < ApplicationRecord
  belongs_to :key_word
  validates :link, uniqueness: true
end
