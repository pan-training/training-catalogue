json.array!(@zenodomaterials) do |zenodomaterial|
  json.extract! zenodomaterial, :id, :title, :url, :short_description, :doi, :remote_updated_date, :remote_created_date
  json.url zenodomaterial_url(zenodomaterial, format: :json)

  json.partial! 'common/ontology_terms', type: 'scientific_topics', resource: zenodomaterial

json.authors(zenodomaterial.bauthors) do |bauthor|
  json.extract! bauthor, :firstname, :lastname, :orcid  
end

json.contributors(zenodomaterial.bcontributors) do |bcontributor|
  json.extract! bcontributor, :firstname, :lastname, :orcid  
end


end


