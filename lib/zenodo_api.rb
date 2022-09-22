require 'json'
require 'net/http'
require 'uri'

module ZenodoApi
  class MyZenodoApi    
    #after testing for stability is done, no need to use the sandbox anymore
    #also no need to set_debug_output once the testing is done
    @@root_url = "https://sandbox.zenodo.org/"
    @@zenodo_token = "input_zenodo_key"    
    
    def create_empty_material_zenodo
        #puts @@root_url
        #puts @@zenodo_token
            
        uri = URI.parse(@@root_url)
        http = Net::HTTP.new(uri.host, uri.port)
        #http.set_debug_output($stdout) # Logger.new("foo.log") works too
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Post.new("/api/deposit/depositions?access_token="+@@zenodo_token)
        request.add_field('Content-Type', 'application/json')
        request.body = "{}"
        response = http.request(request)
        response_body = JSON.parse(response.body)
        deposition_id = response_body["id"]
        puts "deposition_id", deposition_id
        bucket_url = response_body["links"]["bucket"]
        zenodo_array = [deposition_id,bucket_url]
    end
    
    #dont care about this for now
    def upload_file_zenodo(bucket_url,fileeee,filename2)
        bucket_url_parsed = bucket_url.split('/')

        bucket_url_parsed_code = bucket_url_parsed[5]

        uri = URI.parse(@@root_url)

        http = Net::HTTP.new(uri.host, uri.port)
        #http.set_debug_output($stdout) # Logger.new("foo.log") works too
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Put.new("/api/files/"+bucket_url_parsed_code+"/"+filename2+"?access_token="+@@zenodo_token)
        request.add_field('Content-Type', 'application/octet-stream')
        request.body =  File.read(fileeee)
        response = http.request(request)
        
        #puts response
        #puts response.code
        #puts response.message
       
    end

    def publish_zenodo(deposition_id)
        uri = URI.parse(@@root_url)
        http = Net::HTTP.new(uri.host, uri.port)
        #http.set_debug_output($stdout) # Logger.new("foo.log") works too
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Post.new("/api/deposit/depositions/"+deposition_id.to_s+"/actions/publish?access_token="+@@zenodo_token)
        request.add_field('Content-Type', 'application/json')
        response = http.request(request)
        
        response_body = JSON.parse(response.body)
              
        #puts response
        #puts response_body
        
        doi = response_body['doi']
        puts 'doi', doi
        zenodo_link = response_body['links']['latest_html']
        puts 'zenodo_link', zenodo_link
        
        zenodo_array = [doi,zenodo_link]
    end

    def launch_upload_file_zenodo(bucket_url,fileeee)  
          puts "launch_upload_file_zenodo"            
          fileeee.each do |f|
             #puts "original filename"
             #puts f.original_filename
             original_filename = f.original_filename
             #puts "tempfile"
             #puts f.tempfile
             tempfile = f.tempfile
             puts "bucket_url",bucket_url
             puts "original_filename",original_filename
             upload_file_zenodo(bucket_url,tempfile,original_filename)
          end
    end
    
    #dont care about this for now
    def set_material_info_zenodo(deposition_id,title,short_desc,authors,contributors,zenodotype,doi,keywords,publicationdate,zenodolicense,zenodolanguage,publicationtype,imagetype)
    
        array_authors = []       
        authors.each do |f|
            firstname_lastname = f.firstname+', '+f.lastname
            if f.orcid==""
              puts "orcid is an empty string"
              array_authors << {'name': firstname_lastname}            
            else
              puts "orcid is not an empty string"            
              array_authors << {'name': firstname_lastname, 'orcid': f.orcid}            
            end
        end 

        array_contributors = []       
        contributors.each do |f|
            firstname_lastname = f.firstname+', '+f.lastname
            array_contributors << {'name': firstname_lastname, 'type': f.contribtype}
        end

       upload_type = zenodotype
             
       puts "upload_type"
       puts upload_type
       
       puts "the publication date"
       puts publicationdate
       
        #mandatory fields
        data = []
        data << {
             'metadata': {
                 'title': title,
                 'upload_type': upload_type,
                 'description': short_desc,
                 'creators': array_authors
             }
         }

        #optional fields
        #should check it exists before doing the following here
        if !array_contributors.empty?
            puts "array of contributors"
            puts array_contributors
            data[0][:metadata][:contributors] = array_contributors
        end
        
        #this probably does not work, need to check
        if !doi.empty?
          puts "doi"
          data[0][:metadata][:doi] = doi
        end
                
        if !keywords.empty?
          puts "keywords"
          data[0][:metadata][:keywords] = keywords
        end
        
        # .empty? returns false if the string is " ", true if "".
        if !zenodolanguage.empty?
          puts "language"        
          puts zenodolanguage
          data[0][:metadata][:language] = zenodolanguage
        end
        
        if !zenodolicense.empty?
          puts "license"        
          puts zenodolicense
          data[0][:metadata][:license] = zenodolicense
        end
             
             
        #publicationtype,imagetype set em      
        if upload_type=="publication"
          data[0][:metadata][:publication_type] = publicationtype
        elsif upload_type=="image"
          data[0][:metadata][:image_type] = imagetype    
        end      
             
        #make sure this can never be empty in the model, make it a mandatory field if it isn't already.
        data[0][:metadata][:publication_date] = publicationdate
       
        data_json = data[0].to_json
     
        puts "data", data_json

        uri = URI.parse(@@root_url)
        http = Net::HTTP.new(uri.host, uri.port)
        #http.set_debug_output($stdout) # Logger.new("foo.log") works too
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Put.new("/api/deposit/depositions/"+deposition_id.to_s+"?access_token="+@@zenodo_token)
        request.add_field('Content-Type', 'application/json')
        request.body =  data_json
        response = http.request(request)

        #puts response
        #puts response.code
        #puts response.message
  
    end
 
    #UPDATE

    def update_empty_material_zenodo(deposition_id)

        uri = URI.parse(@@root_url)
        http = Net::HTTP.new(uri.host, uri.port)
        #http.set_debug_output($stdout) # Logger.new("foo.log") works too
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Post.new("/api/deposit/depositions/"+deposition_id.to_s+"/actions/edit?access_token="+@@zenodo_token)    
        request.add_field('Content-Type', 'application/json')
        request.body = "{}"
        response = http.request(request)
        response_body = JSON.parse(response.body)
        deposition_id = response_body["id"]
        puts "deposition_id", deposition_id
        #bucket_url = response_body["links"]["bucket"]
        #puts "bucket_url", bucket_url        
        #zenodo_array = [deposition_id,bucket_url]
        zenodo_array = [deposition_id]
    end

    def update_material_info_zenodo(deposition_id,title,short_desc,authors,contributors,zenodotype,keywords,publicationdate,zenodolicense,zenodolanguage,publicationtype,imagetype)
    
        array_authors = []       
        authors.each do |f|
            firstname_lastname = f.firstname+', '+f.lastname
            if f.orcid==""
              puts "orcid is an empty string"
              array_authors << {'name': firstname_lastname}            
            else
              puts "orcid is not an empty string"            
              array_authors << {'name': firstname_lastname, 'orcid': f.orcid}            
            end
        end 

        array_contributors = []       
        contributors.each do |f|
            firstname_lastname = f.firstname+', '+f.lastname
            array_contributors << {'name': firstname_lastname, 'type': f.contribtype}
        end

       upload_type = zenodotype
             
       puts "upload_type"
       puts upload_type
       
       puts "the publication date"
       puts publicationdate
       
        #mandatory fields
        data = []
        data << {
             'metadata': {
                 'title': title,
                 'upload_type': upload_type,
                 'description': short_desc,
                 'creators': array_authors
             }
         }

        #optional fields
        #should check it exists before doing the following here
        if !array_contributors.empty?
            puts "array of contributors"
            puts array_contributors
            data[0][:metadata][:contributors] = array_contributors
        end
        
        #this probably does not work, need to check
        #if !doi.empty?
        #  puts "doi"
        #  data[0][:metadata][:doi] = doi
        #end
                
        if !keywords.empty?
          puts "keywords"
          data[0][:metadata][:keywords] = keywords
        end
        
        # .empty? returns false if the string is " ", true if "".
        if !zenodolanguage.empty?
          puts "language"        
          puts zenodolanguage
          data[0][:metadata][:language] = zenodolanguage
        end
        
        if !zenodolicense.empty?
          puts "license"        
          puts zenodolicense
          data[0][:metadata][:license] = zenodolicense
        end
             
             
        #publicationtype,imagetype set em      
        if upload_type=="publication"
          data[0][:metadata][:publication_type] = publicationtype
        elsif upload_type=="image"
          data[0][:metadata][:image_type] = imagetype    
        end      
             
        #make sure this can never be empty in the model, make it a mandatory field if it isn't already.
        data[0][:metadata][:publication_date] = publicationdate
       
        data_json = data[0].to_json
     
        puts "data", data_json

        uri = URI.parse(@@root_url)
        http = Net::HTTP.new(uri.host, uri.port)
        #http.set_debug_output($stdout) # Logger.new("foo.log") works too
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Put.new("/api/deposit/depositions/"+deposition_id.to_s+"?access_token="+@@zenodo_token)
        request.add_field('Content-Type', 'application/json')
        request.body =  data_json
        response = http.request(request)

        #puts response
        #puts response.code
        #puts response.message
    end

    #only difference here with method publish_zenodo is the request.body = "{}" line which i don't think is necessary
    def update_publish_zenodo(deposition_id)
        uri = URI.parse(@@root_url)
        http = Net::HTTP.new(uri.host, uri.port)
        #http.set_debug_output($stdout) # Logger.new("foo.log") works too
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Post.new("/api/deposit/depositions/"+deposition_id.to_s+"/actions/publish?access_token="+@@zenodo_token)
        request.add_field('Content-Type', 'application/json')
        request.body = "{}"
        response = http.request(request)
        
        response_body = JSON.parse(response.body)
              
        #puts response
        #puts response_body
        
        doi = response_body['doi']
        puts 'doi', doi
        zenodo_link = response_body['links']['latest_html']
        puts 'zenodo_link', zenodo_link
        
        zenodo_array = [doi,zenodo_link]
    end

    #NEW VERSION

    def new_version(deposition_id)
        uri = URI.parse(@@root_url)
        http = Net::HTTP.new(uri.host, uri.port)
        #http.set_debug_output($stdout) # Logger.new("foo.log") works too
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Post.new("/api/deposit/depositions/"+deposition_id.to_s+"/actions/newversion?access_token="+@@zenodo_token)
        request.add_field('Content-Type', 'application/json')
        #request.body = "{}"
        response = http.request(request)
        
        response_body = JSON.parse(response.body)
                             
        latest_draft = response_body["links"]["latest_draft"]
        new_version_parsed = latest_draft.split('/')
        new_version_deposition_id_parsed = new_version_parsed[6]
               
        #puts "new version id"      
        #puts new_version_deposition_id_parsed
              
        #bucket url does not actually stay the same, it changes, so this is useless, delete when code gets refactored      
        bucket_url = response_body["links"]["bucket"]
                        
        zenodo_array = [new_version_deposition_id_parsed,bucket_url]
           
    end

    def list_files(deposition_id)

        uri = URI.parse(@@root_url)
        http = Net::HTTP.new(uri.host, uri.port)
        #http.set_debug_output($stdout) # Logger.new("foo.log") works too
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new("/api/deposit/depositions/"+deposition_id.to_s+"/files?access_token="+@@zenodo_token)
        request.add_field('Content-Type', 'application/json')
        response = http.request(request)
        
        response_body = JSON.parse(response.body)
                      
        id_filename_list = []
           
        response_body.each do |fff|   
            #puts "in list files loop"
            #puts fff["filename"]
                        
            #id_filename_list << [fff["id"],fff["filename"]]
            #this underneath works well with the view
            id_filename_list << {id: fff["id"],filename: fff["filename"]}
        end
                        
        #puts id_filename_list
        id_filename_list
        
    end

    #retrieve deposition and hopefully get the new bucket link this way (this one should not be blocked)
    def retrieve_deposition(deposition_id)

        uri = URI.parse(@@root_url)
        http = Net::HTTP.new(uri.host, uri.port)
        #http.set_debug_output($stdout) # Logger.new("foo.log") works too
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new("/api/deposit/depositions/"+deposition_id.to_s+"?access_token="+@@zenodo_token)
        request.add_field('Content-Type', 'application/json')
        response = http.request(request)
        
        response_body = JSON.parse(response.body)             
        new_version_bucket_url = response_body["links"]["bucket"]
    end    

    def delete_file(deposition_id,file_id)

        uri = URI.parse(@@root_url)
        http = Net::HTTP.new(uri.host, uri.port)
        #http.set_debug_output($stdout) # Logger.new("foo.log") works too
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Delete.new("/api/deposit/depositions/"+deposition_id.to_s+"/files/"+file_id.to_s+"?access_token="+@@zenodo_token)
        request.add_field('Content-Type', 'application/json')
        response = http.request(request)
        puts "file is deleted"
        response_code = response.code #response code should be 204 if success
        
    end

  end
end


