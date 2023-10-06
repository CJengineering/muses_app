require 'rails_helper'

RSpec.describe "posts/new", type: :view do
  before(:each) do
    assign(:post, Post.new(
      key_word: nil,
      title: "MyString",
      published: "MyString",
      link: "MyText",
      category_label: "MyString",
      score: 1,
      score_second: 1,
      source: "MyString"
    ))
  end

  it "renders new post form" do
    render

    assert_select "form[action=?][method=?]", posts_path, "post" do

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
