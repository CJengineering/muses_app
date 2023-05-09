require "application_system_test_case"

class KeyWordsTest < ApplicationSystemTestCase
  setup do
    @key_word = key_words(:one)
  end

  test "visiting the index" do
    visit key_words_url
    assert_selector "h1", text: "Key words"
  end

  test "should create key word" do
    visit key_words_url
    click_on "New key word"

    fill_in "Key word", with: @key_word.key_word
    fill_in "Rss url", with: @key_word.rss_url
    click_on "Create Key word"

    assert_text "Key word was successfully created"
    click_on "Back"
  end

  test "should update Key word" do
    visit key_word_url(@key_word)
    click_on "Edit this key word", match: :first

    fill_in "Key word", with: @key_word.key_word
    fill_in "Rss url", with: @key_word.rss_url
    click_on "Update Key word"

    assert_text "Key word was successfully updated"
    click_on "Back"
  end

  test "should destroy Key word" do
    visit key_word_url(@key_word)
    click_on "Destroy this key word", match: :first

    assert_text "Key word was successfully destroyed"
  end
end
