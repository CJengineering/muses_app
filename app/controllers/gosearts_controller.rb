class GoseartsController < ApplicationController
  before_action :set_goseart, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token
  include Pagy::Backend
  require 'text_analyzer'
  # GET /gosearts or /gosearts.json
  def index
    if params[:status]== "pending" || params[:status]== nil
      @articles_all = Goseart.includes(:key_word).where(category_label: nil)
      json_response = @articles_all.to_json
      render json: json_response
    elsif params[:status]== "published" 
      @articles_all = Goseart.includes(:key_word).where(category_label: "published")
      json_response =@articles_all.to_json
      render json: json_response
    elsif params[:status]== "archived" 
      @articles_all = Goseart.includes(:key_word).where(category_label: "archived")
      json_response =@articles_all.to_json
      render json: json_response
    else
      render json: {"not workin": 0}
    end
  end

  # GET /gosearts/1 or /gosearts/1.json
  def show
    start = Time.now
    keywords = count_words(@goseart.url_link)
    keyword_duration = Time.now - start
    
    start = Time.now
    @related_keywords = keywords[0]
    related_keywords_duration = Time.now - start
  
    start = Time.now
    @array = keywords[1]
    array_duration = Time.now - start
  
    start = Time.now
    text = fetch_raw_text(@goseart.url_link)
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

  # GET /gosearts/new
  def new
    @goseart = Goseart.new
  end

  # GET /gosearts/1/edit
  def edit
  end

  # POST /gosearts or /gosearts.json
  def create
    @goseart = Goseart.new(goseart_params)

    respond_to do |format|
      if @goseart.save
        format.html { redirect_to goseart_url(@goseart), notice: "Goseart was successfully created." }
        format.json { render :show, status: :created, location: @goseart }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @goseart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gosearts/1 or /gosearts/1.json
  def update
    respond_to do |format|
      if @goseart.update(goseart_params)
        format.json { render :show, status: :ok, location: @goseart }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @goseart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gosearts/1 or /gosearts/1.json
  def destroy
    @goseart.destroy

    respond_to do |format|
      format.html { redirect_to gosearts_url, notice: "Goseart was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_goseart
      @goseart = Goseart.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def goseart_params
      params.require(:goseart).permit(:key_word_id, :title, :url_link, :score, :score_second,:category_label)
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
