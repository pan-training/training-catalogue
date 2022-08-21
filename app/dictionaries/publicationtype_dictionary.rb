class PublicationtypeDictionary < Dictionary

  def publication_type_abbreviations
    @abbrvs ||= @dictionary.keys
  end

  def publication_type_names(publication_type_dictionary=@dictionary)
    @publication_type_names ||= publication_type_dictionary.map { |_, value| value['title'] }
  end

  private

  def dictionary_filepath
    File.join(Rails.root, "config", "dictionaries", "publication_types.yml")
  end

end
