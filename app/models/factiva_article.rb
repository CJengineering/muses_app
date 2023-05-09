class FactivaArticle < ApplicationRecord
    belongs_to :key_word
    validates :title, uniqueness: true
end
