FactoryBot.define do
  factory :article do
    score {5}
    score_second {10}
    title {"random title"}
    sequence(:published) {|n| "2#{n}-06-2023"}
    sequence(:link) { |n| "Article #{n}" }
    posted {false}
    key_word_id {1}
    association :key_word, factory: :key_word
  end
end
