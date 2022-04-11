class UnscrapedsController < ApplicationController

  before_action :set_unscraped, only: [:show,  :destroy]
  before_action :set_breadcrumbs

  include SearchableIndex

  def index
    authorize Unscraped
    respond_to do |format|
      format.json
      format.json_api { render({ json: @unscrapeds }.merge(api_collection_properties)) }
      format.html
    end
  end

  def show
    authorize Unscraped
    respond_to do |format|
      format.json
      format.json_api { render json: @unscraped }
      format.html
    end
  end

  # GET /unscrapeds/new
  def new
    authorize Unscraped
    @unscraped = Unscraped.new
  end

  # POST /unscrapeds/check_title
  # POST /unscrapeds/check_title.json
  def check_exists
    @unscraped = Unscraped.check_exists(unscraped_params)

    if @unscraped
      respond_to do |format|
        format.html { redirect_to @unscraped }
        #format.json { render json: @unscraped }
        format.json { render :show, location: @unscraped }
      end
    else
      respond_to do |format|
        format.html { render :nothing => true, :status => 200, :content_type => 'text/html' }
        format.json { render json: {}, :status => 200, :content_type => 'application/json' }
      end
    end
  end

  # POST /unscrapeds
  # POST /unscrapeds.json
  def create
    authorize Unscraped
    @unscraped = Unscraped.new(unscraped_params)
    @unscraped.user = current_user

    respond_to do |format|
      if @unscraped.save
        @unscraped.create_activity :create, owner: current_user
        format.html { redirect_to @unscraped, notice: 'Unscraped was successfully created.' }
        format.json { render :show, status: :created, location: @unscraped }
      else
        format.html { render :new }
        format.json { render json: @unscraped.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unscrapeds/1
  # DELETE /unscrapeds/1.json
  def destroy
    authorize @unscraped
    @unscraped.create_activity :destroy, owner: current_user
    @unscraped.destroy
    respond_to do |format|
      format.html { redirect_to unscrapeds_url, notice: 'Unscraped was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_unscraped
    @unscraped = Unscraped.friendly.find(params[:id])
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def unscraped_params
    params.require(:unscraped).permit(:id, :title, :url, :short_description)
  end

end
