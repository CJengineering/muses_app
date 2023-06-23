require 'rails_helper'

RSpec.describe "gosearts/new", type: :view do
  before(:each) do
    assign(:goseart, Goseart.new(
      key_word: nil,
      title: "MyText",
      url_link: "MyText",
      score: 1,
      score_second: 1
    ))
  end

  it "renders new goseart form" do
    render

    assert_select "form[action=?][method=?]", gosearts_path, "post" do

      assert_select "input[name=?]", "goseart[key_word_id]"

      assert_select "textarea[name=?]", "goseart[title]"

      assert_select "textarea[name=?]", "goseart[url_link]"

      assert_select "input[name=?]", "goseart[score]"

      assert_select "input[name=?]", "goseart[score_second]"
    end
  end
end
