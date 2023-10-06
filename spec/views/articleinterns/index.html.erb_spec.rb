require 'rails_helper'

RSpec.describe "articleinterns/index", type: :view do
  before(:each) do
    assign(:articleinterns, [
      Articleintern.create!(
        title: "Title",
        category_label: "Category Label",
        score: 2,
        score_second: 3,
        published: "Published",
        link: "MyText"
      ),
      Articleintern.create!(
        title: "Title",
        category_label: "Category Label",
        score: 2,
        score_second: 3,
        published: "Published",
        link: "MyText"
      )
    ])
  end

  it "renders a list of articleinterns" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Title".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Category Label".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Published".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
