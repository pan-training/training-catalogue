# Dictionary of languages from http://stevehardie.com/2009/10/list-of-common-languages/
# Converted to yaml and saved to config/dictionaries/languages.yml

class LanguageDictionary < Dictionary

  def language_abbreviations
    @abbrvs ||= @dictionary.keys
  end

  def language_names(language_dictionary=@dictionary)
    @language_names ||= language_dictionary.map { |_, value| value['title'] }
  end

  private

  def dictionary_filepath
    File.join(Rails.root, "config", "dictionaries", "languages.yml")
  end

end
