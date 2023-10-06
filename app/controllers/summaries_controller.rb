class SummariesController < ApplicationController
  before_action :set_summary, only: %i[ show edit update destroy ]

  # GET /summaries or /summaries.json
  def index
    @summaries = Summary.all
  end

  # GET /summaries/1 or /summaries/1.json
  def show
  end

  # GET /summaries/new
  def new
    @summary = Summary.new
  end

  # GET /summaries/1/edit
  def edit
  end

  # POST /summaries or /summaries.json
  def create
    @summary = Summary.new(summary_params)

    respond_to do |format|
      if @summary.save
        format.html { redirect_to summary_url(@summary), notice: "Summary was successfully created." }
        format.json { render :show, status: :created, location: @summary }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @summary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /summaries/1 or /summaries/1.json
  def update
    respond_to do |format|
      if @summary.update(summary_params)
        format.html { redirect_to summary_url(@summary), notice: "Summary was successfully updated." }
        format.json { render :show, status: :ok, location: @summary }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @summary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /summaries/1 or /summaries/1.json
  def destroy
    @summary.destroy

    respond_to do |format|
      format.html { redirect_to summaries_url, notice: "Summary was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_summary
      @summary = Summary.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def summary_params
      params.require(:summary).permit(:article_id,:post_id, :goseart_id, :bing_article_id, :summary_text)
    end
end
