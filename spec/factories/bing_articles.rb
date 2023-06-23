FactoryBot.define do
  factory :bing_article do
    key_word { nil }
    title { "MyString" }
    category_label { "MyString" }
    score { 1 }
    score_second { 1 }
    published { "MyString" }
    link { "MyText" }
  end
end
