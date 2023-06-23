require "rails_helper"

RSpec.describe GoseartsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/gosearts").to route_to("gosearts#index")
    end

    it "routes to #new" do
      expect(get: "/gosearts/new").to route_to("gosearts#new")
    end

    it "routes to #show" do
      expect(get: "/gosearts/1").to route_to("gosearts#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/gosearts/1/edit").to route_to("gosearts#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/gosearts").to route_to("gosearts#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/gosearts/1").to route_to("gosearts#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/gosearts/1").to route_to("gosearts#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/gosearts/1").to route_to("gosearts#destroy", id: "1")
    end
  end
end
