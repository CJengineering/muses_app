class Post < ApplicationRecord
  belongs_to :key_word
  validates :link, uniqueness: true
  has_one :summary,  dependent: :destroy
  def as_json(options = {})
    super(options.merge(include: { key_word: { only: :key_word } }))
  end
end
