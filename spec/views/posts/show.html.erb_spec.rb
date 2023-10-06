require 'rails_helper'

RSpec.describe "posts/show", type: :view do
  before(:each) do
    assign(:post, Post.create!(
      key_word: nil,
      title: "Title",
      published: "Published",
      link: "MyText",
      category_label: "Category Label",
      score: 2,
      score_second: 3,
      source: "Source"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Published/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Category Label/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Source/)
  end
end
