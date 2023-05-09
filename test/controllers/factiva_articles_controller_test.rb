require "test_helper"

class FactivaArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @factiva_article = factiva_articles(:one)
  end

  test "should get index" do
    get factiva_articles_url
    assert_response :success
  end

  test "should get new" do
    get new_factiva_article_url
    assert_response :success
  end

  test "should create factiva_article" do
    assert_difference("FactivaArticle.count") do
      post factiva_articles_url, params: { factiva_article: { description: @factiva_article.description, factiva_link: @factiva_article.factiva_link, posted: @factiva_article.posted, published: @factiva_article.published, title: @factiva_article.title, url_g_1: @factiva_article.url_g_1, url_g_2: @factiva_article.url_g_2 } }
    end

    assert_redirected_to factiva_article_url(FactivaArticle.last)
  end

  test "should show factiva_article" do
    get factiva_article_url(@factiva_article)
    assert_response :success
  end

  test "should get edit" do
    get edit_factiva_article_url(@factiva_article)
    assert_response :success
  end

  test "should update factiva_article" do
    patch factiva_article_url(@factiva_article), params: { factiva_article: { description: @factiva_article.description, factiva_link: @factiva_article.factiva_link, posted: @factiva_article.posted, published: @factiva_article.published, title: @factiva_article.title, url_g_1: @factiva_article.url_g_1, url_g_2: @factiva_article.url_g_2 } }
    assert_redirected_to factiva_article_url(@factiva_article)
  end

  test "should destroy factiva_article" do
    assert_difference("FactivaArticle.count", -1) do
      delete factiva_article_url(@factiva_article)
    end

    assert_redirected_to factiva_articles_url
  end
end
