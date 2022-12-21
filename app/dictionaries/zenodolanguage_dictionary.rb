class ZenodolanguageDictionary < Dictionary

  def zenodo_language_abbreviations
    @abbrvs ||= @dictionary.keys
  end

  def zenodo_language_names(zenodo_language_dictionary=@dictionary)
    @zenodo_language_names ||= zenodo_language_dictionary.map { |_, value| value['title'] }
  end

  private

  def dictionary_filepath
    File.join(Rails.root, "config", "dictionaries", "zenodo_languages.yml")
  end

end
