require 'rails_helper'

RSpec.describe "articleinterns/new", type: :view do
  before(:each) do
    assign(:articleintern, Articleintern.new(
      title: "MyString",
      category_label: "MyString",
      score: 1,
      score_second: 1,
      published: "MyString",
      link: "MyText"
    ))
  end

  it "renders new articleintern form" do
    render

    assert_select "form[action=?][method=?]", articleinterns_path, "post" do

      assert_select "input[name=?]", "articleintern[title]"

      assert_select "input[name=?]", "articleintern[category_label]"

      assert_select "input[name=?]", "articleintern[score]"

      assert_select "input[name=?]", "articleintern[score_second]"

      assert_select "input[name=?]", "articleintern[published]"

      assert_select "textarea[name=?]", "articleintern[link]"
    end
  end
end
