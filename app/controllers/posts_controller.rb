class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  skip_before_action :verify_authenticity_token
  # GET /posts or /posts.json
  def index
    status = params[:status]
    @articles_all = case status
                    when 'incoming', nil
                      Post.includes(:key_word).where(category_label: nil)
                    when 'published'
                      Post.includes(:key_word).where(category_label: 'published')
                    when 'shortlist'
                      Post.includes(:key_word).where(category_label: 'shortlist')
                    when 'archived'
                      Post.includes(:key_word).where(category_label: 'archived')
                    end

    if @articles_all
      @articles_all = @articles_all.order('created_at DESC')
      json_response = @articles_all.to_json
      render json: json_response
    else
      render json: { "not_working": 0 }
    end
  end

  # GET /posts/1 or /posts/1.json
  def show; end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit; end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:key_word_id, :title, :published, :link, :category_label, :score, :score_second,
                                 :source)
  end
end
