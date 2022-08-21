module HasZenodolicense

  extend ActiveSupport::Concern

  included do
    validates :zenodolicense, controlled_vocabulary: { dictionary: ZenodolicenseDictionary.instance }

    if TeSS::Config.solr_enabled
      # :nocov:
      searchable do
        string :zenodolicense do
          ZenodolicenseDictionary.instance.lookup_value(self.zenodolicense, 'title')
        end
        text :zenodolicense
      end
      # :nocov:
    end
  end

  # Allows setting of the license either by using the key (CC-BY-4.0) #
  #  or license URL (https://creativecommons.org/licenses/by/4.0/)
  def zenodolicense= key_or_uri
    id = ZenodolicenseDictionary.instance.lookup_by(:url, key_or_uri).first if key_or_uri =~ URI::regexp
    key_or_uri = id if id

    super(key_or_uri)
  end

end
