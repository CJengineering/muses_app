class GoseartsController < ApplicationController
  before_action :set_goseart, only: %i[ show edit update destroy ]
  include Pagy::Backend

  # GET /gosearts or /gosearts.json
  def index
    @pagy, @gosearts = pagy(Goseart.all)
  end

  # GET /gosearts/1 or /gosearts/1.json
  def show
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
        format.html { redirect_to goseart_url(@goseart), notice: "Goseart was successfully updated." }
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
      params.require(:goseart).permit(:key_word_id, :title, :url_link, :score, :score_second)
    end
end
