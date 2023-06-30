class BingArticlesController < ApplicationController
  before_action :set_bing_article, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token
  require 'open-uri'
  require 'text_analyzer'
  # GET /bing_articles or /bing_articles.json
  def index
    if params[:status]== "pending" || params[:status]== nil
      @articles_all = BingArticle.includes(:key_word).where(category_label: "pending")
      json_response = @articles_all.to_json
      render json: json_response
    elsif params[:status]== "published" 
      @articles_all = BingArticle.includes(:key_word).where(category_label: "published")
      json_response =@articles_all.to_json
      render json: json_response
    elsif params[:status]== "archived" 
      @articles_all = BingArticle.includes(:key_word).where(category_label: "archived")
      json_response =@articles_all.to_json
      render json: json_response
    else
      render json: {"not workin": 0}
    end
  end

  # GET /bing_articles/1 or /bing_articles/1.json
  def show
    start = Time.now
    keywords = count_words(@bing_article.link)
    keyword_duration = Time.now - start
    
    start = Time.now
    @related_keywords = keywords[0]
    related_keywords_duration = Time.now - start
  
    start = Time.now
    @array = keywords[1]
    array_duration = Time.now - start
  
    start = Time.now
    text = fetch_raw_text(@bing_article.link)
    fetch_duration = Time.now - start
  
    start = Time.now
    analyzer = TextAnalyzer.new(text)
    analyzer_duration = Time.now - start
  
    start = Time.now
    @output_text = analyzer.analyze
    analyze_duration = Time.now - start
  
    render json: { 
      text: @output_text, 
      related_keywords: @related_keywords, 
      array: @array, 
      durations: {
        keyword_duration: keyword_duration,
        related_keywords_duration: related_keywords_duration,
        array_duration: array_duration,
        fetch_duration: fetch_duration,
        analyzer_duration: analyzer_duration,
        analyze_duration: analyze_duration
      }
    }
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

    def fetch_raw_text(url)
      begin 
        html = URI.open(url)
        doc = Nokogiri::HTML(html)
        text_elements = doc.css('h1, p')
        return text_elements.map(&:text).join(" ") # Return the concatenated text content of the selected elements
      rescue OpenURI::HTTPError, URI::InvalidURIError, Nokogiri::SyntaxError, SocketError, StandardError => error
        return "An error occurred: #{error}"
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
