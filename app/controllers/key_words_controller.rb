class KeyWordsController < ApplicationController
  before_action :set_key_word, only: %i[show edit update destroy]
  require 'csv'
  skip_before_action :verify_authenticity_token
  # GET /key_words or /key_words.json
  def index
    @key_words = KeyWord.all
    render json: @key_words
  end

  def keyword_posts
    id = params[:id]
    key_word = KeyWord.find(id)
  
    if params[:status] == "incoming" || params[:status].nil?
      posts = key_word.posts.where(category_label: nil)
    elsif params[:status] == "published"
      posts = key_word.posts.where(category_label: "published")
    elsif params[:status] == "shortlist"
      posts = key_word.posts.where(category_label: "shortlist")
    elsif params[:status] == "archived"
      posts = key_word.posts.where(category_label: "archived")
    else
      render json: { error: "Invalid status" }, status: :unprocessable_entity
      return
    end
  
    formatted_posts = posts.map do |post|
      {
        id: post.id,
        key_word_id: post.key_word_id,
        title: post.title,
        published: post.published,
        link: post.link,
        category_label: post.category_label,
        score: post.score,
        score_second: post.score_second,
        source: post.source,
        created_at: post.created_at,
        updated_at: post.updated_at,
        key_word: {
          key_word: key_word.key_word
        }
      }
    end
  
    render json: formatted_posts
  end

  # GET /key_words/1 or /key_words/1.json
  def show
    key_word_json = @key_word.as_json(include: %i[gosearts articles bing_articles])
    render json: key_word_json
  end

  # GET /key_words/new
  def new
    @key_word = KeyWord.new
  end

  # GET /key_words/1/edit
  def edit; end

  # POST /key_words or /key_words.json
  def create
    @key_word = KeyWord.new(key_word_params)

    respond_to do |format|
      if @key_word.save
        format.html { redirect_to key_word_url(@key_word), notice: 'Key word was successfully created.' }
        format.json { render :show, status: :created, location: @key_word }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @key_word.errors, status: :unprocessable_entity }
      end
    end
  end
  # import csv

  def import
    file = params[:file]
    return redirect_to key_words_path, notice: 'Only CSV please' unless file.content_type == 'text/csv'

    CsvImportKeyWordsService.new.call(file)

    redirect_to key_words_path, notice: 'Key words imported '
  end

  # PATCH/PUT /key_words/1 or /key_words/1.json
  def update
    respond_to do |format|
      if @key_word.update(key_word_params)
        format.html { redirect_to key_word_url(@key_word), notice: 'Key word was successfully updated.' }
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
      format.html { redirect_to key_words_url, notice: 'Key word was successfully destroyed.' }
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
    params.require(:key_word).permit(:key_word, :rss_url, :factiva, :file, :combined)
  end
end
