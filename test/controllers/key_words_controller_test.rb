require "test_helper"

class KeyWordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @key_word = key_words(:one)
  end

  test "should get index" do
    get key_words_url
    assert_response :success
  end

  test "should get new" do
    get new_key_word_url
    assert_response :success
  end

  test "should create key_word" do
    assert_difference("KeyWord.count") do
      post key_words_url, params: { key_word: { key_word: @key_word.key_word, rss_url: @key_word.rss_url } }
    end

    assert_redirected_to key_word_url(KeyWord.last)
  end

  test "should show key_word" do
    get key_word_url(@key_word)
    assert_response :success
  end

  test "should get edit" do
    get edit_key_word_url(@key_word)
    assert_response :success
  end

  test "should update key_word" do
    patch key_word_url(@key_word), params: { key_word: { key_word: @key_word.key_word, rss_url: @key_word.rss_url } }
    assert_redirected_to key_word_url(@key_word)
  end

  test "should destroy key_word" do
    assert_difference("KeyWord.count", -1) do
      delete key_word_url(@key_word)
    end

    assert_redirected_to key_words_url
  end
end
