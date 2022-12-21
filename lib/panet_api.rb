require 'json'
require 'net/http'
require 'uri'
require 'httparty'

module PanetApi
  class MyPanetApi

    def initialize()
        @panet_api_url = 'https://pan-ontologies.psi.ch/techniques/pan-ontology'
    end
    
    #either with purl
    #https://pan-ontologies.psi.ch/techniques/pan-ontology?where={"pid":"http://purl.org/pan-science/PaNET/PaNET01135"}
    
    #or name
    #https://pan-ontologies.psi.ch/techniques/pan-ontology?where={"name":"absorption spectroscopy"}
            
    #example
    #for this input :  "absorption spectroscopy" // {"name":"absorption spectroscopy"}
    #returns this: {"pid"=>{"inq"=>["http://purl.org/pan-science/PaNET/PaNET01135", "http://purl.org/pan-science/PaNET/PaNET01196", "http://purl.org/pan-science/PaNET/PaNET01197", "http://purl.org/pan-science/PaNET/PaNET01199", "http://purl.org/pan-science/PaNET/PaNET01198", "http://purl.org/pan-science/PaNET/PaNET01321", "http://purl.org/pan-science/PaNET/PaNET01322"]}}        
    def panet_get_children(technique_name)
        result = HTTParty.get(@panet_api_url+'?where={"name":"'+technique_name+'"}',
           :body => { 
                 })    
        #puts result.code, result.message, result    
        #check code is 200
        unique_purls = result["pid"]["inq"]
        unique_labels = []

        unique_purls.each do |unq_purl|
            unique_labels << BLOB::Ontology.instance.lookup(unq_purl).label
        end

        unique_labels        
    end
 
    
    def or_result_parser(res)
        unique_purls = []
        res_or = res["or"]

        res_or.each do |purl_or|
            res_parsed = purl_or["pid"]["inq"]
            res_parsed.each do |purl|
                #puts purl
                if !unique_purls.include?(purl)
                    unique_purls << purl
                end
            end
        end

        unique_labels = []
        unique_purls.each do |unq_purl|
            unique_labels << BLOB::Ontology.instance.lookup(unq_purl).label
        end
        unique_labels
    end
 
    #example
    #for this input : ["ptychography","nanotomography"] // {"or":[{"name": "ptychography"},{"name": "nanotomography"}]}
    #returns this {"or"=>[{"pid"=>{"inq"=>["http://purl.org/pan-science/PaNET/PaNET01212", "http://purl.org/pan-science/PaNET/PaNET01213"]}}, {"pid"=>{"inq"=>["http://purl.org/pan-science/PaNET/PaNET01154", "http://purl.org/pan-science/PaNET/PaNET01155", "http://purl.org/pan-science/PaNET/PaNET01213"]}}]}
    def panet_get_children_or(array_techniques)
        str = '{"or":['
        length_array = array_techniques.length()
        count=0
        
        array_techniques.each do |technique|
            count+=1
            if count==length_array
                str += '{"name": "'+technique+'"}'
            else
                str += '{"name": "'+technique+'"},'
            end                        
        end
        
        str += ']}'
        
        result = HTTParty.get(@panet_api_url+'?where='+str,
           :body => { 
                 })    
        #puts result.code, result.message, result    
        #check code is 200
        or_result_parser(result)    
    end 

  end
end


