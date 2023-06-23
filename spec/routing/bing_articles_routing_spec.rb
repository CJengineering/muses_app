require "rails_helper"

RSpec.describe BingArticlesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/bing_articles").to route_to("bing_articles#index")
    end

    it "routes to #new" do
      expect(get: "/bing_articles/new").to route_to("bing_articles#new")
    end

    it "routes to #show" do
      expect(get: "/bing_articles/1").to route_to("bing_articles#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/bing_articles/1/edit").to route_to("bing_articles#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/bing_articles").to route_to("bing_articles#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/bing_articles/1").to route_to("bing_articles#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/bing_articles/1").to route_to("bing_articles#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/bing_articles/1").to route_to("bing_articles#destroy", id: "1")
    end
  end
end
