require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'factory' do
    it 'is valid' do
      article = FactoryBot.build(:article)
      expect(article).to be_valid
    end
  end
  context 'has a score ' do
    it 'has a score ' do
      article = FactoryBot.build(:article)
      expect(article.score).to eq(5)
    end
    it 'has a score_second ' do
      article = FactoryBot.build(:article)
      expect(article.score_second).to eq(10)
    end
  end
end
