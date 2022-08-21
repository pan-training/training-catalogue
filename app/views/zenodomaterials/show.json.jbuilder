json.extract! @zenodomaterial, :id, :title, :url, :short_description, :doi, :remote_updated_date, :remote_created_date,
              :created_at, :updated_at, :content_provider_id, :keywords, :zenodolicense

json.partial! 'common/ontology_terms', type: 'scientific_topics', resource: @zenodomaterial

json.authors(@zenodomaterial.bauthors) do |bauthor|
  json.extract! bauthor, :firstname, :lastname, :orcid  
end

json.contributors(@zenodomaterial.bcontributors) do |bcontributor|
  json.extract! bcontributor, :firstname, :lastname, :orcid  
end
