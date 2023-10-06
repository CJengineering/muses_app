class GoseartsController < ApplicationController
  before_action :set_goseart, only: %i[show edit update destroy]
  skip_before_action :verify_authenticity_token
  include Pagy::Backend
  require 'open-uri'
  require 'text_analyzer'

  # GET /gosearts or /gosearts.json
  def index
    if params[:status] == 'pending' || params[:status].nil?
      @articles_all = Goseart.includes(:key_word).where(category_label: nil).order('created_at DESC')
      json_response = @articles_all.to_json
      render json: json_response
    elsif params[:status] == 'published'
      @articles_all = Goseart.includes(:key_word).where(category_label: 'published').order('created_at DESC')
      json_response = @articles_all.to_json
      render json: json_response
    elsif params[:status] == 'archived'
      @articles_all = Goseart.includes(:key_word).where(category_label: 'archived').order('created_at DESC')
      json_response = @articles_all.to_json
      render json: json_response
    else
      render json: { "not workin": 0 }
    end
  end

  # GET /gosearts/1 or /gosearts/1.json
  def show
    keywords = count_words(@goseart.url_link)
    @related_keywords = keywords[0]
    @array = keywords[1]
    @summary_text = @goseart.summary ? @goseart.summary.summary_text : 'Not summerised'
    render json: {
      related_keywords: @related_keywords,
      array: @array,
      summary: @summary_text
    }
  end

  # GET /gosearts/new
  def new
    @goseart = Goseart.new
  end

  # GET /gosearts/1/edit
  def edit; end

  # POST /gosearts or /gosearts.json
  def create
    @goseart = Goseart.new(goseart_params)

    respond_to do |format|
      if @goseart.save
        format.html { redirect_to goseart_url(@goseart), notice: 'Goseart was successfully created.' }
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
      format.html { redirect_to gosearts_url, notice: 'Goseart was successfully destroyed.' }
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
    params.require(:goseart).permit(:key_word_id, :title, :url_link, :score, :score_second, :category_label)
  end

  def fetch_raw_text(url)
    html = URI.open(url)
    doc = Nokogiri::HTML(html)
    text_elements = doc.css('h1, p')
    text_elements.map(&:text).join(' ') # Return the concatenated text content of the selected elements
  rescue OpenURI::HTTPError, URI::InvalidURIError, Nokogiri::SyntaxError, SocketError, StandardError => e
    "An error occurred: #{e}"
  end

  def count_words(url)
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
      occurrences = doc.text.scrub('').scan(/#{word}/i).size
      array << occurrences
      # Store the count in the hash
      word_counts[word] = occurrences
    end

    # Return the word counts
    [word_counts, array.sum]
  rescue OpenURI::HTTPError => e
    array = 0
    [word_counts, array]
  rescue URI::InvalidURIError => e
    array = 0
    [word_counts, array]
  rescue Nokogiri::SyntaxError => e
    array = 0
    [word_counts, array]
  rescue SocketError => e
    array = 0
    [word_counts, array]
  rescue StandardError => e
    array = 0
    [word_counts, array.

      end]
  end
end
