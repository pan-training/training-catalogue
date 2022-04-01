class Unscraped < ApplicationRecord

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
      text :short_description
 
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
    validates :title, :short_description, :url, presence: true
 
 
  def self.facet_fields
    %w( title user)
  end 
 
 
  def self.check_exists(unscraped_params)
    given_unscraped = self.new(unscraped_params)
    unscraped = nil

    if given_unscraped.url.present?
      unscraped = self.find_by_url(given_unscraped.url)
    end
    unscraped
  end  
    
    
end
