class ZenodomaterialsController < ApplicationController
  before_action :set_zenodomaterial, only: [:show, :edit, :update, :destroy, :update_packages, :add_term, :reject_term, :unscrape]
  before_action :set_breadcrumbs

  include SearchableIndex
  include ActionView::Helpers::TextHelper
  include FieldLockEnforcement
  include TopicCuration

  # GET /zenodomaterials
  # GET /zenodomaterials?q=queryparam
  # GET /zenodomaterials.json
  # GET /zenodomaterials.json?q=queryparam

  def index
    respond_to do |format|
      format.json
      format.json_api { render({ json: @zenodomaterials }.merge(api_collection_properties)) }
      format.html
    end
  end

  # GET /zenodomaterials/1
  # GET /zenodomaterials/1.json
  # TODO: This is probably not a good way of concealing an individual record from a user.
  # TODO: In any case, it breaks various tests.
  def show
    respond_to do |format|
      format.json
      format.json_api { render json: @zenodomaterial }
      format.html
    end
  end

  # GET /zenodomaterials/new
  def new
    authorize Zenodomaterial
    @zenodomaterial = Zenodomaterial.new
  end

  # GET /zenodomaterials/1/edit
  def edit
    authorize @zenodomaterial
  end

  # POST /zenodomaterials/check_title
  # POST /zenodomaterials/check_title.json
  def check_exists
    @zenodomaterial = ZenodoMaterial.check_exists(zenodomaterial_params)

    if @zenodomaterial
      respond_to do |format|
        format.html { redirect_to @zenodomaterial }
        #format.json { render json: @zenodomaterial }
        format.json { render :show, location: @zenodomaterial }
      end
    else
      respond_to do |format|
        format.html { render :nothing => true, :status => 200, :content_type => 'text/html' }
        format.json { render json: {}, :status => 200, :content_type => 'application/json' }
      end
    end
  end

  # POST /zenodomaterials
  # POST /zenodomaterials.json
  def create
    authorize Zenodomaterial
    @zenodomaterial = Zenodomaterial.new(zenodomaterial_params)
    @zenodomaterial.user = current_user

    respond_to do |format|
      if @zenodomaterial.save
        @zenodomaterial.create_activity :create, owner: current_user
        
        #we should save material in db, save + publish material on zenodo, if we get url back give it to the material
        #if we dont get url back, delete material
                                        
        service = ZenodoApi::MyZenodoApi.new         
        array_depid_burl =  service.create_empty_material_zenodo      
        service.set_material_info_zenodo(array_depid_burl[0], @zenodomaterial.title, @zenodomaterial.short_description,@zenodomaterial.bauthors,@zenodomaterial.bcontributors,@zenodomaterial.zenodotype,@zenodomaterial.doi,@zenodomaterial.keywords,@zenodomaterial.publicationdate,@zenodomaterial.zenodolicense,@zenodomaterial.zenodolanguage,@zenodomaterial.publicationtype,@zenodomaterial.imagetype)       
        bucket_url = array_depid_burl[1]        
        
        #comment this out for testing/debugging purposes
        #service.upload_file_zenodo(bucket_url,@zenodomaterial.fileeeee.tempfile,@zenodomaterial.fileeeee.original_filename) old, new way is underneath, takes into account multiple uploads
        
        service.launch_upload_file_zenodo(bucket_url,@zenodomaterial.fileeeee)
        
        #@zenodomaterial.url = "placeholder"
        
        #comment this out for testing/debugging purposes
        doi_link =  service.publish_zenodo(array_depid_burl[0])      
        @zenodomaterial.url = doi_link[1]
        @zenodomaterial.doi = doi_link[0]
        #end of the commenting out
        @zenodomaterial.save
        
        format.html { redirect_to @zenodomaterial, notice: 'Zenodomaterial was successfully created.' }
        format.json { render :show, status: :created, location: @zenodomaterial }
      else
        format.html { render :new }
        format.json { render json: @zenodomaterial.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /zenodomaterials/1
  # PATCH/PUT /zenodomaterials/1.json
  def update
    authorize @zenodomaterial
    respond_to do |format|
      if @zenodomaterial.update(zenodomaterial_params)
        @zenodomaterial.create_activity(:update, owner: current_user) if @zenodomaterial.log_update_activity?
        format.html { redirect_to @zenodomaterial, notice: 'Zenodo material was successfully updated.' }
        format.json { render :show, status: :ok, location: @zenodomaterial }
      else
        format.html { render :edit }
        format.json { render json: @zenodomaterial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /zenodomaterials/1
  # DELETE /zenodomaterials/1.json
  def destroy
    authorize @zenodomaterial
    @zenodomaterial.create_activity :destroy, owner: current_user
    @zenodomaterial.destroy
    respond_to do |format|
      format.html { redirect_to zenodomaterials_url, notice: 'Zenodo material was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  
  def unscrape
    #verification here that its a scraped Zenodo material
    authorize @zenodomaterial
    #we do this condition in the view so normally the condition will always be true
    #if not, there is no redirection to any view but that does not matter much
    if !@zenodomaterial.last_scraped.nil? && @zenodomaterial.scraper_record                
        #create the unscraped Zenodo material 
        #authorize Unscraped, the authorize will be done in the new of the Unscraped controller
        @unscraped = Unscraped.new(:title=> @zenodomaterial.title, :url=> @zenodomaterial.url, :short_description=> @zenodomaterial.short_description)
        @unscraped.user = current_user
        
        if @unscraped.save
        @unscraped.create_activity :create, owner: current_user
        end       
         
        #delete the Zenodo material
        #authorize @zenodomaterial, already did an authorize at the beginning
        @zenodomaterial.create_activity :destroy, owner: current_user
        @zenodomaterial.destroy
        respond_to do |format|
          format.html { redirect_to zenodomaterials_url, notice: 'Zenodo material was successfully destroyed and will no longer be scraped.' }
          format.json { head :no_content }
        end    
    end
  end  
  

  # POST /zenodomaterials/1/update_packages
  # POST /zenodomaterials/1/update_packages.json
  def update_packages
    # Go through each selected package
    # and update its resources to include this zenodo material.
    # Go through each other package that is not selected and remove this zenodo material from it.
    packages = params[:zenodomaterial][:package_ids].select{|p| !p.blank?}
    packages = packages.collect{|package| Package.find_by_id(package)}
    packages_to_remove = @zenodomaterial.packages - packages
    packages.each do |package|
      package.update_resources_by_id(nil, (package.zenodomaterials + [@zenodomaterial.id]).uniq, nil)
    end
    packages_to_remove.each do |package|
      package.update_resources_by_id(nil, (package.zenodomaterials.collect{|x| x.id} - [@zenodomaterial.id]).uniq, nil)
    end
    flash[:notice] = "Zenodo material has been included in #{pluralize(packages.count, 'package')}"
    redirect_to @zenodomaterial
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_zenodomaterial
    @zenodomaterial = Zenodomaterial.friendly.find(params[:id])
  end

  
  # Never trust parameters from the scary internet, only allow the white list through.
  def zenodomaterial_params
    params.require(:zenodomaterial).permit(:id, :title, :url, :short_description, :doi,:last_scraped, :scraper_record,
                                     :remote_created_date,  :remote_updated_date, {:fileeeee => []},  {:package_ids => []},
                                     :content_provider_id, {:keywords => []}, {:resource_type => []},
                                     {:scientific_topic_names => []}, {:scientific_topic_uris => []},                                     
                                     :zenodolicense, :zenodolanguage, :zenodotype, :publicationdate, :publicationtype, :imagetype,                                   
                                     bauthors_attributes: [:id, :firstname, :lastname, :orcid, :_destroy],
                                     bcontributors_attributes: [:id, :firstname, :lastname, :contribtype, :orcid, :_destroy], event_ids: [],
                                     locked_fields: [])
  end



end
