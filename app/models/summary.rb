class Summary < ApplicationRecord
  belongs_to :article, optional: true
  belongs_to :goseart, optional: true
  belongs_to :bing_article, optional: true
  belongs_to :articleintern, optional: true
  belongs_to :post, optional: true
  validate :validate_summarizable_association

  private

  def validate_summarizable_association
    return if [article, goseart, bing_article, articleintern, post].compact.size == 1

    errors.add(:base, 'Summary must belong to exactly one of Article, Goseart, or BingArticle')
  end
end
