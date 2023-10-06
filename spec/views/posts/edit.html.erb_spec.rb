require 'rails_helper'

RSpec.describe "posts/edit", type: :view do
  let(:post) {
    Post.create!(
      key_word: nil,
      title: "MyString",
      published: "MyString",
      link: "MyText",
      category_label: "MyString",
      score: 1,
      score_second: 1,
      source: "MyString"
    )
  }

  before(:each) do
    assign(:post, post)
  end

  it "renders the edit post form" do
    render

    assert_select "form[action=?][method=?]", post_path(post), "post" do

      assert_select "input[name=?]", "post[key_word_id]"

      assert_select "input[name=?]", "post[title]"

      assert_select "input[name=?]", "post[published]"

      assert_select "textarea[name=?]", "post[link]"

      assert_select "input[name=?]", "post[category_label]"

      assert_select "input[name=?]", "post[score]"

      assert_select "input[name=?]", "post[score_second]"

      assert_select "input[name=?]", "post[source]"
    end
  end
end
