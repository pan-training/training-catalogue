json.array!(@eventunscrapeds) do |eventunscraped|
  json.extract! eventunscraped, :id, :title, :url
  json.url eventunscraped_url(eventunscraped, format: :json)

end


