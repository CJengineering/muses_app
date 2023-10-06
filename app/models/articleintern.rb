class Articleintern < ApplicationRecord
    has_one :summary
    belongs_to :key_word, optional: true


  def as_json(options = {})
    super(options.merge(include: { key_word: { only: :key_word } }))
  end
end
