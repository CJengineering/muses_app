require 'rails_helper'

RSpec.describe "summaries/index", type: :view do
  before(:each) do
    assign(:summaries, [
      Summary.create!(
        article: nil,
        goseart: nil,
        bing_article: nil,
        summary_text: "MyText"
      ),
      Summary.create!(
        article: nil,
        goseart: nil,
        bing_article: nil,
        summary_text: "MyText"
      )
    ])
  end

  it "renders a list of summaries" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
