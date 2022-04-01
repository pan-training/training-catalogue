class Eventunscraped < ApplicationRecord

  include PublicActivity::Common
  include LogParameterChanges  
  include Searchable
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
 
      time :updated_at
      time :created_at

      string :user do
        user.username if user
      end
      integer :user_id # Used for shadowbans
    end
    # :nocov:
  end

    belongs_to :user
    validates :title, :url, presence: true
 
  def self.facet_fields
    %w( title user)
  end 
 
  def self.check_exists(eventunscraped_params)
    given_eventunscraped = self.new(eventunscraped_params)
    eventunscraped = nil

    if given_eventunscraped.url.present?
      eventunscraped = self.find_by_url(given_eventunscraped.url)
    end
    eventunscraped
  end  
    
    
end
