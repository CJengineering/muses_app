require 'rails_helper'

RSpec.describe "gosearts/edit", type: :view do
  let(:goseart) {
    Goseart.create!(
      key_word: nil,
      title: "MyText",
      url_link: "MyText",
      score: 1,
      score_second: 1
    )
  }

  before(:each) do
    assign(:goseart, goseart)
  end

  it "renders the edit goseart form" do
    render

    assert_select "form[action=?][method=?]", goseart_path(goseart), "post" do

      assert_select "input[name=?]", "goseart[key_word_id]"

      assert_select "textarea[name=?]", "goseart[title]"

      assert_select "textarea[name=?]", "goseart[url_link]"

      assert_select "input[name=?]", "goseart[score]"

      assert_select "input[name=?]", "goseart[score_second]"
    end
  end
end
