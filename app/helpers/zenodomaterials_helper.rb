module ZenodomaterialsHelper
  MATERIALS_INFO = "In the context the #{TeSS::Config.generic_name}, a training material is a link to a single online training material sourced by a content provider (such as a text on a Web page, presentation, video, etc.) along with description and other meta information (e.g. ontological categorization, keywords, etc.).\n\n"\
  "The #{TeSS::Config.generic_name} harvests materials automatically from our E-learning platform, including descriptions and other relevant meta-data made available by providers. Materials can also be registered manually.\n\n"\
  "If your website contains training materials that you wish to include in our #{TeSS::Config.generic_name}, please contact our team (<a href='#{TeSS::Config.contact_email}'>#{TeSS::Config.contact_email}</a>) for further details.".freeze

  ELEARNING_MATERIALS_INFO = "e-Learning materials are curated materials focused on e-Learning.\n\n"\
  "If your website contains e-Learning materials that you wish to include in our #{TeSS::Config.generic_name}, please contact our team (<a href='#{TeSS::Config.contact_email}'>#{TeSS::Config.contact_email}</a>) for further details.".freeze

  TOPICS_INFO = "The #{TeSS::Config.generic_name} generates a scientific topic suggestion for each resource registered. It does this by
  passing the description and title of the resource to the Bioportal Annotator Web service.
The Annotator Web service finds EDAM terms that match terms in the text. You can then accept or reject these terms in our #{TeSS::Config.generic_name}.

Accepting will add a topic to the resource and rejecting will remove the suggestion permanently"
  # Returns an array of two-element arrays of licences ready to be used in options_for_select() for generating option/select tags
  # [['Licence 1 full name','Licence 1 abbreviation'], ['Licence 2 full name','Licence 2 abbreviation'], ...]
 #def licence_options_for_select
 #   LicenceDictionary.instance.options_for_select
 # end

  #def licence_name_for_abbreviation(licence)
  #  LicenceDictionary.instance.lookup_value(licence, 'title')
  #end

  def language_options_for_select
    LanguageDictionary.instance.options_for_select
  end

  def language_name_for_abbreviation(language)
    LanguageDictionary.instance.lookup_value(language, 'title')
  end

  def zenodolanguage_options_for_select
    ZenodolanguageDictionary.instance.options_for_select
  end

  def zenodolanguage_name_for_abbreviation(zenodolanguage)
    ZenodolanguageDictionary.instance.lookup_value(zenodolanguage, 'title')
  end

  def zenodotype_options_for_select
    ZenodotypeDictionary.instance.options_for_select
  end

  def zenodotype_name_for_abbreviation(zenodotype)
    ZenodotypeDictionary.instance.lookup_value(zenodotype, 'title')
  end
  
  def publicationtype_options_for_select
    PublicationtypeDictionary.instance.options_for_select
  end

  def publicationtype_name_for_abbreviation(publicationtype)
    PublicationtypeDictionary.instance.lookup_value(publicationtype, 'title')
  end

  def imagetype_options_for_select
    ImagetypeDictionary.instance.options_for_select
  end

  def imagetype_name_for_abbreviation(imagetype)
    ImagetypeDictionary.instance.lookup_value(imagetype, 'title')
  end

  def contributortype_options_for_select
    ContributortypeDictionary.instance.options_for_select
  end

  def contributortype_name_for_abbreviation(contributortype)
    ContributortypeDictionary.instance.lookup_value(contributortype, 'title')
  end

  def zenodolicense_options_for_select
    ZenodolicenseDictionary.instance.options_for_select
  end

  def zenodolicense_name_for_abbreviation(zenodolicense)
    ZenodolicenseDictionary.instance.lookup_value(zenodolicense, 'title')
  end

  def display_attribute(resource, attribute) # resource e.g. <#Material> & symbol e.g. :target_audience
    value = resource.send(attribute)
    if value.blank? || value.try(:strip) == 'notspecified'
      string = "<p class=\"#{attribute}\">"
    else
      string = "<p class=\"#{attribute}\"><b> #{resource.class.human_attribute_name(attribute)}: </b>"
      string << (block_given? ? yield(value) : value.to_s)
    end
    (string + '</p>').html_safe
  end
end
