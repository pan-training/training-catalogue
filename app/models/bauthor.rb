class Bauthor < ApplicationRecord
  has_and_belongs_to_many :materials

  has_and_belongs_to_many :zenodomaterials
  
  validates :firstname, presence: true
  validates :lastname, presence: true 
  #an empty space is allowed (two aren't). This is why we use blank? in the view
  validates :orcid, length: {is: 19}, allow_blank: true

   
   if TeSS::Config.solr_enabled
    # :nocov:
    searchable do
      string :firstname, :multiple => true
      text :firstname  
      string :lastname, :multiple => true
      text :lastname  
      
      #string :resource_type, :multiple => true
      #text :resource_type      
    end
    # :nocov:
  end
 
 
 
 
 
end
