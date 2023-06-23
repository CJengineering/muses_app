class BingArticlesController < ApplicationController
  before_action :set_bing_article, only: %i[ show edit update destroy ]

  # GET /bing_articles or /bing_articles.json
  def index
    @bing_articles = BingArticle.all
  end

  # GET /bing_articles/1 or /bing_articles/1.json
  def show
  end

  # GET /bing_articles/new
  def new
    @bing_article = BingArticle.new
  end

  # GET /bing_articles/1/edit
  def edit
  end

  # POST /bing_articles or /bing_articles.json
  def create
    @bing_article = BingArticle.new(bing_article_params)

    respond_to do |format|
      if @bing_article.save
        format.html { redirect_to bing_article_url(@bing_article), notice: "Bing article was successfully created." }
        format.json { render :show, status: :created, location: @bing_article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bing_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bing_articles/1 or /bing_articles/1.json
  def update
    respond_to do |format|
      if @bing_article.update(bing_article_params)
        format.html { redirect_to bing_article_url(@bing_article), notice: "Bing article was successfully updated." }
        format.json { render :show, status: :ok, location: @bing_article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bing_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bing_articles/1 or /bing_articles/1.json
  def destroy
    @bing_article.destroy

    respond_to do |format|
      format.html { redirect_to bing_articles_url, notice: "Bing article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bing_article
      @bing_article = BingArticle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bing_article_params
      params.require(:bing_article).permit(:key_word_id, :title, :category_label, :score, :score_second, :published, :link)
    end
end
