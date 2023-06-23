require 'rails_helper'

RSpec.describe "KeyWords", type: :request do
  describe "GET /key_words" do
    it "works! (now write some real specs)" do
      get key_words_path
      expect(response).to have_http_status(200)
    end
  end
end
