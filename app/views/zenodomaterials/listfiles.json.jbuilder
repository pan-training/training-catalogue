json.array!(@id_filename_list) do |id_filename|
  json.extract! id_filename, :id, :filename
end
