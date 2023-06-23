require 'rails_helper'

RSpec.describe "bing_articles/edit", type: :view do
  let(:bing_article) {
    BingArticle.create!(
      key_word: nil,
      title: "MyString",
      category_label: "MyString",
      score: 1,
      score_second: 1,
      published: "MyString",
      link: "MyText"
    )
  }

  before(:each) do
    assign(:bing_article, bing_article)
  end

  it "renders the edit bing_article form" do
    render

    assert_select "form[action=?][method=?]", bing_article_path(bing_article), "post" do

      assert_select "input[name=?]", "bing_article[key_word_id]"

      assert_select "input[name=?]", "bing_article[title]"

      assert_select "input[name=?]", "bing_article[category_label]"

      assert_select "input[name=?]", "bing_article[score]"

      assert_select "input[name=?]", "bing_article[score_second]"

      assert_select "input[name=?]", "bing_article[published]"

      assert_select "textarea[name=?]", "bing_article[link]"
    end
  end
end
