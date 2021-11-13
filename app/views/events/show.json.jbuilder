fields = [:id, :external_id,:title, :subtitle, :url, :organizer, :description,
              :start, :end, :sponsors, :venue, :city, :county, :country, :postcode,
              :latitude, :longitude, :created_at, :updated_at, :source, :slug, :content_provider_id,
              :user_id, :online, :cost, :for_profit, :last_scraped, :scraper_record, :keywords,
              :event_types, :target_audience, :capacity, :eligibility, :contact, :host_institutions]

fields += Event::SENSITIVE_FIELDS if policy(@event).view_report?

json.extract! @event, *fields

json.partial! 'common/ontology_terms', type: 'scientific_topics', resource: @event

json.nodes @event.associated_nodes.collect{|x| {:name => x[:name], :node_id => x[:id] } }

  
json.external_resources(@event.external_resources) do |external_resource|
  json.partial! 'common/external_resource', external_resource: external_resource  
end


