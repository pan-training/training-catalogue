class ZenodolicenseDictionary < Dictionary

  def zenodo_license_abbreviations
    @abbrvs ||= @dictionary.keys
  end

  def zenodo_license_names(zenodo_license_dictionary=@dictionary)
    @zenodo_license_names ||= zenodo_license_dictionary.map { |_, value| value['title'] }
  end

  private

  def dictionary_filepath
    File.join(Rails.root, "config", "dictionaries", "zenodo_licenses.yml")
  end

end
