require 'rails_helper'

RSpec.describe "Static", type: :request do
  describe "GET /" do
    it "works! root and home " do
      get root_path
      expect(response).to have_http_status(200)
    end
  end

  context "GET static/test" do
    it "works on creation new articles  " do
       get static_test_path
       expect(response).to have_http_status(:success) 
    end
  end
end
