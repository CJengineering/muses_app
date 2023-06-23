require 'rails_helper'

RSpec.describe "gosearts/index", type: :view do
  before(:each) do
    assign(:gosearts, [
      Goseart.create!(
        key_word: nil,
        title: "MyText",
        url_link: "MyText",
        score: 2,
        score_second: 3
      ),
      Goseart.create!(
        key_word: nil,
        title: "MyText",
        url_link: "MyText",
        score: 2,
        score_second: 3
      )
    ])
  end

  it "renders a list of gosearts" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
  end
end
