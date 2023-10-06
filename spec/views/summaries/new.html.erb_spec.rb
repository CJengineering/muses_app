require 'rails_helper'

RSpec.describe "summaries/new", type: :view do
  before(:each) do
    assign(:summary, Summary.new(
      article: nil,
      goseart: nil,
      bing_article: nil,
      summary_text: "MyText"
    ))
  end

  it "renders new summary form" do
    render

    assert_select "form[action=?][method=?]", summaries_path, "post" do

      assert_select "input[name=?]", "summary[article_id]"

      assert_select "input[name=?]", "summary[goseart_id]"

      assert_select "input[name=?]", "summary[bing_article_id]"

      assert_select "textarea[name=?]", "summary[summary_text]"
    end
  end
end
