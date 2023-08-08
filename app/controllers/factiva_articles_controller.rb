class FactivaArticlesController < ApplicationController
  before_action :set_factiva_article, only: %i[ show edit update destroy ]
  #skip_before_action :verify_authenticity_token
 # before_action :authenticate_devise_api_token!, :resource_class
  # GET /factiva_articles or /factiva_articles.json
  def  resource_class  
  end

  def index
    @factiva_articles = FactivaArticle.all
    render json: @factiva_articles 
  end

  # GET /factiva_articles/1 or /factiva_articles/1.json
  def show
  end

  # GET /factiva_articles/new
  def new
    @factiva_article = FactivaArticle.new
  end

  # GET /factiva_articles/1/edit
  def edit
  end

  # POST /factiva_articles or /factiva_articles.json
  def create
    @factiva_article = FactivaArticle.new(factiva_article_params)

    respond_to do |format|
      if @factiva_article.save
        format.html { redirect_to factiva_article_url(@factiva_article), notice: "Factiva article was successfully created." }
        format.json { render :show, status: :created, location: @factiva_article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @factiva_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /factiva_articles/1 or /factiva_articles/1.json
  def update
    respond_to do |format|
      if @factiva_article.update(factiva_article_params)
        format.html { redirect_to factiva_articles_path notice: "Factiva article was successfully updated." }
        format.json { render :show, status: :ok, location: @factiva_article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @factiva_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /factiva_articles/1 or /factiva_articles/1.json
  def destroy
    @factiva_article.destroy

    respond_to do |format|
      format.html { redirect_to factiva_articles_url, notice: "Factiva article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_factiva_article
      @factiva_article = FactivaArticle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def factiva_article_params
      params.require(:factiva_article).permit(:title, :description, :factiva_link, :published, :posted, :url_g_1, :url_g_2, :author)
    end
end
