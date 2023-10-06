require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/articleinterns", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # Articleintern. As you add validations to Articleintern, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Articleintern.create! valid_attributes
      get articleinterns_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      articleintern = Articleintern.create! valid_attributes
      get articleintern_url(articleintern)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_articleintern_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      articleintern = Articleintern.create! valid_attributes
      get edit_articleintern_url(articleintern)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Articleintern" do
        expect {
          post articleinterns_url, params: { articleintern: valid_attributes }
        }.to change(Articleintern, :count).by(1)
      end

      it "redirects to the created articleintern" do
        post articleinterns_url, params: { articleintern: valid_attributes }
        expect(response).to redirect_to(articleintern_url(Articleintern.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Articleintern" do
        expect {
          post articleinterns_url, params: { articleintern: invalid_attributes }
        }.to change(Articleintern, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post articleinterns_url, params: { articleintern: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested articleintern" do
        articleintern = Articleintern.create! valid_attributes
        patch articleintern_url(articleintern), params: { articleintern: new_attributes }
        articleintern.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the articleintern" do
        articleintern = Articleintern.create! valid_attributes
        patch articleintern_url(articleintern), params: { articleintern: new_attributes }
        articleintern.reload
        expect(response).to redirect_to(articleintern_url(articleintern))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        articleintern = Articleintern.create! valid_attributes
        patch articleintern_url(articleintern), params: { articleintern: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested articleintern" do
      articleintern = Articleintern.create! valid_attributes
      expect {
        delete articleintern_url(articleintern)
      }.to change(Articleintern, :count).by(-1)
    end

    it "redirects to the articleinterns list" do
      articleintern = Articleintern.create! valid_attributes
      delete articleintern_url(articleintern)
      expect(response).to redirect_to(articleinterns_url)
    end
  end
end