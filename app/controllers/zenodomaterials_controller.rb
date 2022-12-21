class ZenodomaterialsController < ApplicationController
  before_action :set_zenodomaterial, only: [:show, :edit, :update, :destroy, :update_packages, :add_term, :reject_term, :unscrape, :newversionedit, :newversionupdate, :listfiles, :deletezenodofile, :newversionzenodo, :aaaaaaaaaaaaaaaaa]
  before_action :set_breadcrumbs
  
  #set class variable that will be used in the zenodo_api constructor
  @@root_url = Rails.application.config_for(:tess)["zenodo"][:url]

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

    @zenodomaterial.vfile = true

    respond_to do |format|
      if @zenodomaterial.save
        @zenodomaterial.create_activity :create, owner: current_user
        
        #we should save material in db, save + publish material on zenodo, if we get url back give it to the material
        #if we dont get url back, delete material
                                        
        service = ZenodoApi::MyZenodoApi.new(@@root_url, get_zenodo_token)
        array_depid_burl =  service.create_empty_material_zenodo
        
        #condition seems to work
        #puts @zenodomaterial.doi
        if !@zenodomaterial.doi.empty?
          #puts "doi is not empty"
          zenodo_doi_boolean = false
        else
          #puts "doi is empty"
          zenodo_doi_boolean = true
        end
        
        service.set_material_info_zenodo(array_depid_burl[0], @zenodomaterial.title, @zenodomaterial.short_description,@zenodomaterial.bauthors,@zenodomaterial.bcontributors,@zenodomaterial.zenodotype,@zenodomaterial.doi,@zenodomaterial.keywords,@zenodomaterial.publicationdate,@zenodomaterial.zenodolicense,@zenodomaterial.zenodolanguage,@zenodomaterial.publicationtype,@zenodomaterial.imagetype)       
        bucket_url = array_depid_burl[1]        
                
        service.launch_upload_file_zenodo(bucket_url,@zenodomaterial.fileeeee)
                        
        #comment this out for testing/debugging purposes
        doi_link =  service.publish_zenodo(array_depid_burl[0])

        @zenodomaterial.zenodoid = array_depid_burl[0]
        @zenodomaterial.zenodolatestid = array_depid_burl[0]
              
        @zenodomaterial.bucketurl = bucket_url
              
        @zenodomaterial.url = doi_link[1]
        @zenodomaterial.doi = doi_link[0]
        
        @zenodomaterial.zenododoibool = zenodo_doi_boolean
        
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
    @zenodomaterial.vfile = false #file is not a mandatory field here     
    respond_to do |format|
      if @zenodomaterial.update(zenodomaterial_params)                       
        @zenodomaterial.create_activity(:update, owner: current_user) if @zenodomaterial.log_update_activity?
       
        service = ZenodoApi::MyZenodoApi.new(@@root_url, get_zenodo_token)
        my_deposition_id = @zenodomaterial.zenodolatestid
        
        array_depid_burl =  service.update_empty_material_zenodo(my_deposition_id)   
        #puts array_depid_burl[0]
        #puts "this is the id update empty gives us back"     
        service.update_material_info_zenodo(my_deposition_id, @zenodomaterial.title, @zenodomaterial.short_description,@zenodomaterial.bauthors,@zenodomaterial.bcontributors,@zenodomaterial.zenodotype,@zenodomaterial.keywords,@zenodomaterial.publicationdate,@zenodomaterial.zenodolicense,@zenodomaterial.zenodolanguage,@zenodomaterial.publicationtype,@zenodomaterial.imagetype)       
        doi_link = service.update_publish_zenodo(my_deposition_id)
        puts doi_link[0], doi_link[1], "should be the same as creation's doi and link here"
                           
        @zenodomaterial.save
               
        format.html { redirect_to @zenodomaterial, notice: 'Zenodo material was successfully updated.' }
        format.json { render :show, status: :ok, location: @zenodomaterial }
      else
        format.html { render :edit }
        format.json { render json: @zenodomaterial.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  
  
  # GET /zenodomaterials/1/newversionedit
  def newversionedit
    authorize @zenodomaterial
  end  

  # PATCH/PUT /zenodomaterials/1/newversionupdate
  def newversionupdate
    authorize @zenodomaterial
    
    #if number of files is 0, file field is mandatory, otherwise it isn't
    #check if this works
    listoffiles = listfiles
    if listoffiles.empty?
      @zenodomaterial.vfile = true
    else
      @zenodomaterial.vfile = false
    end
    
    respond_to do |format|
      if @zenodomaterial.update(zenodomaterial_params)
        puts "in newversionupdate"       
        @zenodomaterial.create_activity(:update, owner: current_user) if @zenodomaterial.log_update_activity? #will this work with the new routes?

        service = ZenodoApi::MyZenodoApi.new(@@root_url, get_zenodo_token)
        my_deposition_id = @zenodomaterial.zenodolatestid
        my_bucket_url = @zenodomaterial.bucketurl
        
        service.update_material_info_zenodo(my_deposition_id, @zenodomaterial.title, @zenodomaterial.short_description,@zenodomaterial.bauthors,@zenodomaterial.bcontributors,@zenodomaterial.zenodotype,@zenodomaterial.keywords,@zenodomaterial.publicationdate,@zenodomaterial.zenodolicense,@zenodomaterial.zenodolanguage,@zenodomaterial.publicationtype,@zenodomaterial.imagetype) 
              
        service.launch_upload_file_zenodo(my_bucket_url,@zenodomaterial.fileeeee)
        puts "id and bucket url" 
        puts my_deposition_id
        puts my_bucket_url       
                        
        #comment this out for testing/debugging purposes
        doi_link =  service.publish_zenodo(my_deposition_id)

        #we come back to the same situation as when we first create the zmaterial
        #zenodoid and zenodolatestid are equal
        @zenodomaterial.zenodoid = my_deposition_id
              
        @zenodomaterial.url = doi_link[1]
        @zenodomaterial.doi = doi_link[0]
        #end of the commenting out
        
        @zenodomaterial.save        
        
        format.html { redirect_to @zenodomaterial, notice: 'Zenodo material was successfully updated.' }
        format.json { render :show, status: :ok, location: @zenodomaterial }
      else
        format.html { render :newversionedit }
        format.json { render json: @zenodomaterial.errors, status: :unprocessable_entity }
      end
    end
  end


  #call to zenodo list files
  #this assumes that the new version has exactly the same files as the older version at first
  def listfiles
      authorize Zenodomaterial
      puts "listing the files"
      my_deposition_id = @zenodomaterial.zenodolatestid      
      service = ZenodoApi::MyZenodoApi.new(@@root_url, get_zenodo_token)
      @id_filename_list = service.list_files(my_deposition_id)
      puts @id_filename_list
      
      @id_filename_list
  end
  helper_method :listfiles
  
  #call to zenodo delete file
  def deletezenodofile
      authorize Zenodomaterial
      puts "deleting the file"
      puts params[:file_id]
      file_id = params[:file_id]
      my_deposition_id = @zenodomaterial.zenodolatestid
      service = ZenodoApi::MyZenodoApi.new(@@root_url, get_zenodo_token)
      service.delete_file(my_deposition_id,file_id)
  end

  #call to zenodo, create new version
  #im expecting that if one presses this a second time, either an error or the same exact response comes back, will have to deal with that
  def newversionzenodo
      authorize Zenodomaterial
      puts "new version zenodo, after button press"

      service = ZenodoApi::MyZenodoApi.new(@@root_url, get_zenodo_token)
      my_deposition_id = @zenodomaterial.zenodolatestid  
      #if @zmat.zenodolatestid is equal to @zmat.id, then do what is underneath (button has never been pressed)
      #if it isn't, dont do what is underneath (button has already been pressed), no need to make api calls again. already saved new id and new bucket link.
      
      if @zenodomaterial.zenodolatestid == @zenodomaterial.zenodoid
        array_depid_burl = service.new_version(my_deposition_id)
        
        @zenodomaterial.zenodolatestid = array_depid_burl[0]
 
        new_version_bucket_url = service.retrieve_deposition(array_depid_burl[0])  
        puts "the new version id"
        puts array_depid_burl[0]
        puts "the new bucket link"
        puts new_version_bucket_url     
                                                                              
        @zenodomaterial.bucketurl = new_version_bucket_url                          
        @zenodomaterial.save
      end

  end
  
  #might use this by calling it ajaxly instead of calling from the view listfiles directly
  def aaaaaaaaaaaaaaaaa
      puts "aaa controller method"      
      respond_to do |format|
          format.js
      end
  end  


  def zenodoredirect
    puts "zenodo redirect"
    
    if !current_user.nil?
        if current_user.profile.zenodotokenchoice.nil?
            redirect_to zenodochoiceedit_path(current_user), alert: "Choose whether you want to use your own or PaN's Zenodo account."
        else 
            if current_user.profile.zenodotokenchoice 
                if session[:zenodo_access_token] 
                    redirect_to new_zenodomaterial_path, notice: "You are using your own Zenodo account."
                else              
                    redirect_to zenodochoiceedit_path(current_user), alert: 'Click on the Zenodo logo, link your account to PaN again.'
                end         
            else                
                redirect_to new_zenodomaterial_path, notice: "You are using PaN's Zenodo account."
            end
        end
    else
        redirect_to new_user_session_path, alert: 'You need to be signed-in.'
    end
   
  end
    
  # DELETE /zenodomaterials/1
  # DELETE /zenodomaterials/1.json
  def destroy
    authorize @zenodomaterial
    @zenodomaterial.create_activity :destroy, owner: current_user
    @zenodomaterial.destroy
    respond_to do |format|
      format.html { redirect_to zenodomaterials_url, notice: 'Zenodo material was successfully destroyed from the catalogue (not from Zenodo, it can not be).' }
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

  def get_zenodo_token
      #true, use their zenodo account, false use ours
      current_user.profile.zenodotokenchoice ? session[:zenodo_access_token] : Rails.application.secrets[:zenodo][:token]
  end

  
  # Never trust parameters from the scary internet, only allow the white list through.
  def zenodomaterial_params
    params.require(:zenodomaterial).permit(:id, :title, :url, :short_description, :doi,:last_scraped, :scraper_record,
                                     :remote_created_date,  :remote_updated_date,:vfile, {:fileeeee => []},  {:package_ids => []},
                                     :content_provider_id, {:keywords => []}, {:resource_type => []},
                                     {:scientific_topic_names => []}, {:scientific_topic_uris => []},                                     
                                     :zenodolicense, :zenodolanguage, :zenodotype, :publicationdate, :publicationtype, :imagetype,                                   
                                     bauthors_attributes: [:id, :firstname, :lastname, :orcid, :_destroy],
                                     bcontributors_attributes: [:id, :firstname, :lastname, :contribtype, :orcid, :_destroy], event_ids: [],
                                     locked_fields: [])
  end



end
