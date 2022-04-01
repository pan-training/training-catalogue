class EventunscrapedsController < ApplicationController

  before_action :set_eventunscraped, only: [:show,  :destroy]
  before_action :set_breadcrumbs

  include SearchableIndex

  def index
    authorize Eventunscraped  
    respond_to do |format|
      format.json
      format.json_api { render({ json: @eventunscrapeds }.merge(api_collection_properties)) }
      format.html
    end
  end

  def show
    authorize Eventunscraped  
    respond_to do |format|
      format.json
      format.json_api { render json: @eventunscraped }
      format.html
    end
  end

  # GET /eventunscrapeds/new
  def new
    authorize Eventunscraped
    @eventunscraped = Eventunscraped.new
  end

  # POST /eventunscrapeds/check_title
  # POST /eventunscrapeds/check_title.json
  def check_exists
    #authorize Eventunscraped
    #cant do this here, the user is not passed when the scraper calls this, no idea why ... user is nil ... weird
    @eventunscraped = Eventunscraped.check_exists(eventunscraped_params)
    
    if @eventunscraped
      respond_to do |format|
        format.html { redirect_to @eventunscraped }
        #format.json { render json: @eventunscraped }
        format.json { render :show, location: @eventunscraped }
      end
    else
      respond_to do |format|
        format.html { render :nothing => true, :status => 200, :content_type => 'text/html' }
        format.json { render json: {}, :status => 200, :content_type => 'application/json' }
      end
    end
  end

  # POST /eventunscrapeds
  # POST /eventunscrapeds.json
  def create
    authorize Eventunscraped
    @eventunscraped = Eventunscraped.new(eventunscraped_params)
    @eventunscraped.user = current_user

    respond_to do |format|
      if @eventunscraped.save
        @eventunscraped.create_activity :create, owner: current_user
        format.html { redirect_to @eventunscraped, notice: 'Eventunscraped was successfully created.' }
        format.json { render :show, status: :created, location: @eventunscraped }
      else
        format.html { render :new }
        format.json { render json: @eventunscraped.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eventunscrapeds/1
  # DELETE /eventunscrapeds/1.json
  def destroy
    authorize @eventunscraped
    @eventunscraped.create_activity :destroy, owner: current_user
    @eventunscraped.destroy
    respond_to do |format|
      format.html { redirect_to eventunscrapeds_url, notice: 'Eventunscraped was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_eventunscraped
    @eventunscraped = Eventunscraped.friendly.find(params[:id])
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def eventunscraped_params
    params.require(:eventunscraped).permit(:id, :title, :url)
  end

end
