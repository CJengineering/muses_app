require 'rails_helper'

RSpec.describe "articleinterns/show", type: :view do
  before(:each) do
    assign(:articleintern, Articleintern.create!(
      title: "Title",
      category_label: "Category Label",
      score: 2,
      score_second: 3,
      published: "Published",
      link: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Category Label/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Published/)
    expect(rendered).to match(/MyText/)
  end
end
