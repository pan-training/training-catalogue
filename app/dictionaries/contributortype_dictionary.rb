class ContributortypeDictionary < Dictionary

  def contributor_type_abbreviations
    @abbrvs ||= @dictionary.keys
  end

  def contributor_type_names(contributor_type_dictionary=@dictionary)
    @contributor_type_names ||= contributor_type_dictionary.map { |_, value| value['title'] }
  end

  private

  def dictionary_filepath
    File.join(Rails.root, "config", "dictionaries", "contributors_type.yml")
  end

end
