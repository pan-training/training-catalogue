require 'json'
require 'net/http'
require 'uri'

module ZenodoApi
  class MyZenodoApi    
    @@root_url = "https://sandbox.zenodo.org/"
    @@zenodo_token = "input_zenodo_key"    
    
    def create_empty_material_zenodo
        puts @@root_url
        puts @@zenodo_token
            
        uri = URI.parse(@@root_url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.set_debug_output($stdout) # Logger.new("foo.log") works too
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
        http.set_debug_output($stdout) # Logger.new("foo.log") works too
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
        http.set_debug_output($stdout) # Logger.new("foo.log") works too
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Post.new("/api/deposit/depositions/"+deposition_id.to_s+"/actions/publish?access_token="+@@zenodo_token)
        request.add_field('Content-Type', 'application/json')
        response = http.request(request)
        
        response_body = JSON.parse(response.body)
              
        #puts response
        
        doi = response_body['doi']
        puts 'doi', doi
        zenodo_link = response_body['links']['latest']
        puts 'zenodo_link', zenodo_link
        
        zenodo_array = [doi,zenodo_link]
    end

    def test(fileeee)
        puts "file"
        puts fileeee
    end
    
    #dont care about this for now
    def set_material_info_zenodo(deposition_id,title,short_desc,authors,contributors,zenodotype,doi,keywords,publicationdate,zenodolicense,zenodolanguage)
    
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
        if !doi==""
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
             
        #make sure this can never be empty in the model, make it a mandatory field if it isn't already.
        data[0][:metadata][:publication_date] = publicationdate
       
        data_json = data[0].to_json
     
        puts "data", data_json

        uri = URI.parse(@@root_url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.set_debug_output($stdout) # Logger.new("foo.log") works too
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
 
  end
end


