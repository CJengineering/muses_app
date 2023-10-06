class ArticleinternsController < ApplicationController
  before_action :set_articleintern, only: %i[show edit update destroy]
  skip_before_action :verify_authenticity_token
  require 'open-uri'
  require 'text_analyzer'
  # GET /articleinterns or /articleinterns.json
  def index
    if params[:status] == 'pending' || params[:status].nil?
      @articles_all = Articleintern.includes(:key_word).where(category_label: nil).order('created_at DESC')
      json_response = @articles_all.to_json
      render json: json_response
    elsif params[:status] == 'published'
      @articles_all = Articleintern.includes(:key_word).where(category_label: 'published').order('created_at DESC')
      json_response = @articles_all.to_json
      render json: json_response
    elsif params[:status] == 'archived'
      @articles_all = Articleintern.includes(:key_word).where(category_label: 'archived').order('created_at DESC')
      json_response = @articles_all.to_json
      render json: json_response
    else
      render json: { "not workin": 0 }
    end
  end

  # GET /articleinterns/1 or /articleinterns/1.json
  def show
    keywords = count_words(@articleintern.link)
    @related_keywords = keywords[0]
    @array = keywords[1]
    @summary_text = @articleintern.summary ? @articleintern.summary.summary_text : 'Not summerised'
    render json: {
      related_keywords: @related_keywords,
      array: @array,
      summary: @summary_text
    }
  end

  # GET /articleinterns/new
  def new
    @articleintern = Articleintern.new
  end

  # GET /articleinterns/1/edit
  def edit; end

  # POST /articleinterns or /articleinterns.json
  def create
    @articleintern = Articleintern.new(articleintern_params)

    respond_to do |format|
      if @articleintern.save
        format.html { redirect_to articleintern_url(@articleintern), notice: 'Articleintern was successfully created.' }
        format.json { render :show, status: :created, location: @articleintern }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @articleintern.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articleinterns/1 or /articleinterns/1.json
  def update
    respond_to do |format|
      if @articleintern.update(articleintern_params)
        format.html { redirect_to articleintern_url(@articleintern), notice: 'Articleintern was successfully updated.' }
        format.json { render :show, status: :ok, location: @articleintern }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @articleintern.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articleinterns/1 or /articleinterns/1.json
  def destroy
    @articleintern.destroy

    respond_to do |format|
      format.html { redirect_to articleinterns_url, notice: 'Articleintern was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_articleintern
    @articleintern = Articleintern.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def articleintern_params
    params.require(:articleintern).permit(:key_word_id, :key_word, :title, :category_label, :score, :score_second,
                                          :published, :link)
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
