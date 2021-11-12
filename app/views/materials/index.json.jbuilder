json.array!(@materials) do |material|
  json.extract! material, :id, :title, :url, :short_description, :doi, :remote_updated_date, :remote_created_date
  json.url material_url(material, format: :json)

  json.partial! 'common/ontology_terms', type: 'scientific_topics', resource: material




json.external_resources(material.external_resources) do |external_resource|
  json.partial! 'common/external_resource', external_resource: external_resource  
end

json.authors(material.bauthors) do |bauthor|
  json.extract! bauthor, :firstname, :lastname, :orcid  
end

json.contributors(material.bcontributors) do |bcontributor|
  json.extract! bcontributor, :firstname, :lastname, :orcid  
end


end


