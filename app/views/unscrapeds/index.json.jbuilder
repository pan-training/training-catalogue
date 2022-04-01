json.array!(@unscrapeds) do |unscraped|
  json.extract! unscraped, :id, :title, :url, :short_description
  json.url unscraped_url(unscraped, format: :json)

end


