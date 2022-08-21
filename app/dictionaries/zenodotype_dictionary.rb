class ZenodotypeDictionary < Dictionary

  def zenodo_type_abbreviations
    @abbrvs ||= @dictionary.keys
  end

  def zenodo_type_names(zenodo_type_dictionary=@dictionary)
    @zenodo_type_names ||= zenodo_type_dictionary.map { |_, value| value['title'] }
  end

  private

  def dictionary_filepath
    File.join(Rails.root, "config", "dictionaries", "zenodo_types.yml")
  end

end
