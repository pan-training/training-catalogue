class ImagetypeDictionary < Dictionary

  def image_type_abbreviations
    @abbrvs ||= @dictionary.keys
  end

  def image_type_names(image_type_dictionary=@dictionary)
    @image_type_names ||= image_type_dictionary.map { |_, value| value['title'] }
  end

  private

  def dictionary_filepath
    File.join(Rails.root, "config", "dictionaries", "image_types.yml")
  end

end
