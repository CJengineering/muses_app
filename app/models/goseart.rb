class Goseart < ApplicationRecord
  belongs_to :key_word
  validates :url_link, uniqueness: true
end
