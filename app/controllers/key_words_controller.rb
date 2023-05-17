class KeyWordsController < ApplicationController
  before_action :set_key_word, only: %i[ show edit update destroy ]
  require 'csv'

  # GET /key_words or /key_words.json
  def index
    @key_words = KeyWord.all
  end

  # GET /key_words/1 or /key_words/1.json
  def show
  
 
  end

  # GET /key_words/new
  def new
    @key_word = KeyWord.new
  end

  # GET /key_words/1/edit
  def edit
  end

  # POST /key_words or /key_words.json
  def create
    @key_word = KeyWord.new(key_word_params)

    respond_to do |format|
      if @key_word.save
        format.html { redirect_to key_word_url(@key_word), notice: "Key word was successfully created." }
        format.json { render :show, status: :created, location: @key_word }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @key_word.errors, status: :unprocessable_entity }
      end
    end
  end
 #import csv

 def import
  file =params[:file]
  return redirect_to key_words_path, notice: "Only CSV please" unless  file.content_type == "text/csv"
  CsvImportKeyWordsService.new.call(file)

  redirect_to key_words_path, notice: "Key words imported "
end
  # PATCH/PUT /key_words/1 or /key_words/1.json
  def update
    respond_to do |format|
      if @key_word.update(key_word_params)
        format.html { redirect_to key_word_url(@key_word), notice: "Key word was successfully updated." }
        format.json { render :show, status: :ok, location: @key_word }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @key_word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /key_words/1 or /key_words/1.json
  def destroy
    @key_word.destroy

    respond_to do |format|
      format.html { redirect_to key_words_url, notice: "Key word was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_key_word
      @key_word = KeyWord.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def key_word_params
      params.require(:key_word).permit(:key_word, :rss_url, :factiva, :file)
    end
end
