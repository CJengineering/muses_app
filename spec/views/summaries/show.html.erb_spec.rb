require 'rails_helper'

RSpec.describe "summaries/show", type: :view do
  before(:each) do
    assign(:summary, Summary.create!(
      article: nil,
      goseart: nil,
      bing_article: nil,
      summary_text: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
  end
end
