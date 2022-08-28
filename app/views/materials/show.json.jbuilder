json.extract! @material, :id, :title, :url, :short_description, :doi, :deliverable, :remote_updated_date, :remote_created_date,
              :created_at, :updated_at, :content_provider_id, :keywords, :licence,
              :difficulty_level,  :target_audience, :language

json.partial! 'common/ontology_terms', type: 'scientific_topics', resource: @material


json.external_resources(@material.external_resources) do |external_resource|
  json.partial! 'common/external_resource', external_resource: external_resource  
end

json.authors(@material.bauthors) do |bauthor|
  json.extract! bauthor, :firstname, :lastname, :orcid  
end

json.contributors(@material.bcontributors) do |bcontributor|
  json.extract! bcontributor, :firstname, :lastname, :orcid  
end
