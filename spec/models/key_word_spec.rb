require 'rails_helper'

RSpec.describe KeyWord, type: :model do
  describe 'factory' do
    it 'is valid' do
      keyword = FactoryBot.build(:key_word)
      expect(keyword).to be_valid
    end
  end

  describe "has latest news less then 72 hours" do
    it 'has a news less then 72 hours' do
      keyword = FactoryBot.build(:key_word)
      FactoryBot.create_list(:article, 3, key_word: keyword)

      expect(keyword.has_new_article).to eq(true)
    end
  end
end
