require 'rails_helper'

RSpec.describe "gosearts/show", type: :view do
  before(:each) do
    assign(:goseart, Goseart.create!(
      key_word: nil,
      title: "MyText",
      url_link: "MyText",
      score: 2,
      score_second: 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
