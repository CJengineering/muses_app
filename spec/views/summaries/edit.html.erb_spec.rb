require 'rails_helper'

RSpec.describe "summaries/edit", type: :view do
  let(:summary) {
    Summary.create!(
      article: nil,
      goseart: nil,
      bing_article: nil,
      summary_text: "MyText"
    )
  }

  before(:each) do
    assign(:summary, summary)
  end

  it "renders the edit summary form" do
    render

    assert_select "form[action=?][method=?]", summary_path(summary), "post" do

      assert_select "input[name=?]", "summary[article_id]"

      assert_select "input[name=?]", "summary[goseart_id]"

      assert_select "input[name=?]", "summary[bing_article_id]"

      assert_select "textarea[name=?]", "summary[summary_text]"
    end
  end
end
