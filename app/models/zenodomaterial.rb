require 'rails/html/sanitizer'

class Zenodomaterial < ApplicationRecord
  include PublicActivity::Common
  include LogParameterChanges
  include HasBauthors
  include HasBcontributors
  include HasContentProvider
  include HasZenodolicense
  include LockableFields
  include Scrapable
  include Searchable
  include CurationQueue
  include HasSuggestions
  include IdentifiersDotOrg
  include HasFriendlyId

  if TeSS::Config.solr_enabled
    # :nocov:
    searchable do
      text :title
      string :title
      string :sort_title do
        title.downcase.gsub(/^(an?|the) /, '')
      end
      text :short_description
      text :doi
      string :scientific_topics, :multiple => true do
        self.scientific_topic_names
      end
      
      string :keywords, :multiple => true
      text :keywords
      string :resource_type, :multiple => true
      text :resource_type

      string :content_provider do
        self.content_provider.try(:title)
      end
      text :content_provider do
        self.content_provider.try(:title)
      end

      time :updated_at
      time :created_at
      time :last_scraped
      boolean :failing do
        failing?
      end
      string :user do
        user.username if user
      end
      integer :user_id # Used for shadowbans
    end
    # :nocov:
  end

  attr_accessor :fileeeee
  attr_accessor :vfile
  
  # has_one :owner, foreign_key: "id", class_name: "User"
  belongs_to :user
  has_one :link_monitor, as: :lcheck, dependent: :destroy

  has_many :package_zenodomaterials
  has_many :packages, through: :package_zenodomaterials
  has_many :event_zenodomaterials, dependent: :destroy
  has_many :events, through: :event_zenodomaterials


  #external ressources could be added?
  has_ontology_terms(:scientific_topics, branch: OBO_BLOB.topics)

  
  # Remove trailing and squeezes (:squish option) white spaces inside the string (before_validation):
  # e.g. "James     Bond  " => "James Bond"
  auto_strip_attributes :title, :short_description, :squish => false

  validates :title, :short_description, :zenodotype, presence: true

  validates :fileeeee, presence: true, if: :validate_file?

  validates :bauthors, presence: true
  
  #conditional validation, check to see if the following works
  #validates_presence_of :, :if => lambda { |o| o.type != 1 }
  validates_presence_of :publicationtype, :if => lambda { |o| o.zenodotype == "publication" }  
  validates_presence_of :imagetype, :if => lambda { |o| o.zenodotype == "image" }  

  validates :zenodolicense, controlled_vocabulary: { dictionary: ZenodolicenseDictionary.instance }
  validates :zenodolanguage, controlled_vocabulary: { dictionary: ZenodolanguageDictionary.instance }
  validates :zenodotype, controlled_vocabulary: { dictionary: ZenodotypeDictionary.instance }
  validates :publicationtype, controlled_vocabulary: { dictionary: PublicationtypeDictionary.instance }
  validates :imagetype, controlled_vocabulary: { dictionary: ImagetypeDictionary.instance }
          
  clean_array_fields(:keywords, :resource_type)

  update_suggestions(:keywords, :resource_type)

  def short_description= desc
    super(Rails::Html::FullSanitizer.new.sanitize(desc))
  end


  def self.facet_fields
    %w(  scientific_topics keywords author contributor zenodolicense content_provider user resource_type)
  end

  def self.check_exists(zenodomaterial_params)
    given_zenodomaterial = self.new(zenodomaterial_params)
    zenodomaterial = nil

    if given_zenodomaterial.url.present?
      zenodomaterial = self.find_by_url(given_zenodomaterial.url)
    end

    if given_zenodomaterial.content_provider.present? && given_zenodomaterial.title.present?
      zenodomaterial ||= self.where(content_provider_id: given_zenodomaterial.content_provider_id,
                                   title: given_zenodomaterial.title).last
    end

    zenodomaterial
  end
  
  
  def validate_file?
    puts vfile
    vfile == true
  end  
  
end
