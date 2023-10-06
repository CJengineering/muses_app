FactoryBot.define do
  factory :post do
    key_word { nil }
    title { "MyString" }
    published { "MyString" }
    link { "MyText" }
    category_label { "MyString" }
    score { 1 }
    score_second { 1 }
    source { "MyString" }
  end
end
