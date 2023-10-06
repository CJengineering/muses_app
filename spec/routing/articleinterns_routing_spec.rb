require "rails_helper"

RSpec.describe ArticleinternsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/articleinterns").to route_to("articleinterns#index")
    end

    it "routes to #new" do
      expect(get: "/articleinterns/new").to route_to("articleinterns#new")
    end

    it "routes to #show" do
      expect(get: "/articleinterns/1").to route_to("articleinterns#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/articleinterns/1/edit").to route_to("articleinterns#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/articleinterns").to route_to("articleinterns#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/articleinterns/1").to route_to("articleinterns#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/articleinterns/1").to route_to("articleinterns#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/articleinterns/1").to route_to("articleinterns#destroy", id: "1")
    end
  end
end
