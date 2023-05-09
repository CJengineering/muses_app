require "application_system_test_case"

class FactivaArticlesTest < ApplicationSystemTestCase
  setup do
    @factiva_article = factiva_articles(:one)
  end

  test "visiting the index" do
    visit factiva_articles_url
    assert_selector "h1", text: "Factiva articles"
  end

  test "should create factiva article" do
    visit factiva_articles_url
    click_on "New factiva article"

    fill_in "Description", with: @factiva_article.description
    fill_in "Factiva link", with: @factiva_article.factiva_link
    check "Posted" if @factiva_article.posted
    fill_in "Published", with: @factiva_article.published
    fill_in "Title", with: @factiva_article.title
    fill_in "Url g 1", with: @factiva_article.url_g_1
    fill_in "Url g 2", with: @factiva_article.url_g_2
    click_on "Create Factiva article"

    assert_text "Factiva article was successfully created"
    click_on "Back"
  end

  test "should update Factiva article" do
    visit factiva_article_url(@factiva_article)
    click_on "Edit this factiva article", match: :first

    fill_in "Description", with: @factiva_article.description
    fill_in "Factiva link", with: @factiva_article.factiva_link
    check "Posted" if @factiva_article.posted
    fill_in "Published", with: @factiva_article.published
    fill_in "Title", with: @factiva_article.title
    fill_in "Url g 1", with: @factiva_article.url_g_1
    fill_in "Url g 2", with: @factiva_article.url_g_2
    click_on "Update Factiva article"

    assert_text "Factiva article was successfully updated"
    click_on "Back"
  end

  test "should destroy Factiva article" do
    visit factiva_article_url(@factiva_article)
    click_on "Destroy this factiva article", match: :first

    assert_text "Factiva article was successfully destroyed"
  end
end
