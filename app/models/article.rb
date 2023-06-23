class Article < ApplicationRecord
  belongs_to :key_word
  validates :link, uniqueness: true

  def as_json(options = {})
    super(options.merge(include: { key_word: { only: :key_word } }))
  end
end
