class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token
  include ActionView::Helpers::SanitizeHelper

  include Pagy::Backend
  require 'open-uri'
  require 'text_analyzer'
  # GET /articles or /articles.json
  def index
    if params[:status]== "pending" || params[:status]== nil
      @articles_all = Article.includes(:key_word).where(category_label: nil).order("created_at DESC")
      json_response =@articles_all.to_json
      render json: json_response
    elsif params[:status]== "published" 
      @articles_all = Article.includes(:key_word).where(category_label: "published").order("created_at DESC")
      json_response =@articles_all.to_json
      render json: json_response
    elsif params[:status]== "archived" 
      @articles_all = Article.includes(:key_word).where(category_label: "archived").order("created_at DESC")
      json_response =@articles_all.to_json
      render json: json_response
    else
      render json: {"not workin": 0}
    end

     

    #@articles =Article.order(published: :desc)
    # if params[:sort_by] == "asc"
    #   @articles = Article.order(published: :asc)
    # elsif params[:date]
    #   @articles = Article.where(published: Date.parse(params[:date]).beginning_of_day..Date.parse(params[:date]).end_of_day)
    # else
    #   @articles =Article.order(published: :desc)
    # end

   
  end

  # GET /articles/1 or /articles/1.json
  def show
    keywords = count_words(@article.link)
    @related_keywords = keywords[0]
    @array = keywords[1]
    @summary_text = @article.summary ? @article.summary.summary_text : 'Not summerised'
    render json: {
      related_keywords: @related_keywords,
      array: @array,
      summary: @summary_text
    }
  end
  
 
  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
      
        format.turbo_stream {render :update, locals: {article: @article}}
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

  


    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:key_word_id, :title, :published, :link, :posted, :category_label, :score)
    end

    def check_order(params) 
      order = if params == 'desc' || params.nil?
        "desc"
         elsif params == 'asc'
          "asc"
         end
    end

    def count_words(url)
      begin 
            html = URI.open(url)
            doc = Nokogiri::HTML(html)
          
            # Define the words you want to search for
            words_to_search = KeyWord.pluck(:key_word).freeze
          
            # Initialize a hash to store the word counts
            word_counts = Hash.new(0)
            array = []
            # Iterate over each word and count its occurrences
            words_to_search.each do |word|
              # Find all occurrences of the word in the webpage content
              occurrences =doc.text.scrub('').scan(/#{word}/i).size
              array << occurrences
              # Store the count in the hash
              word_counts[word] = occurrences
            end
          
            # Return the word counts
            return word_counts, array.sum

            rescue OpenURI::HTTPError => error
              word_counts 
              array =0
              return  word_counts, array
            rescue URI::InvalidURIError => error
              word_counts 
              array =0
              return  word_counts, array
            rescue Nokogiri::SyntaxError => error
              word_counts 
              array =0
              return  word_counts, array
            rescue SocketError => error
              word_counts 
              array =0
              return  word_counts, array
            rescue StandardError => error
              word_counts 
              array=0
              return  word_counts, array.
        
    
            end
          end 
        end 
      end