module HasBauthors

  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :bauthors
    accepts_nested_attributes_for :bauthors, allow_destroy: true
    #before_validation :remove_duplicate_external_resourcess

    if TeSS::Config.solr_enabled
      # :nocov:
      searchable do
        #need the text otherwise the search through materials wont work...
        text :firstname do
          self.bauthors.collect(&:firstname)
        end
        string :firstname, multiple: true do
          self.bauthors.collect(&:firstname)
        end
        
        text :lastname do
          self.bauthors.collect(&:lastname) 
        end        
        string :lastname, multiple: true do
          self.bauthors.collect(&:lastname)
        end
        

        text :author do
          self.bauthors.pluck(:firstname,:lastname)
          #self.bauthors.select_all(:lastname,:firstname) 
          #self.bauthors.collect(:firstname).collect(:name)
          #.join (", ") makes it so that we see firstnam, lastname, and thats nice but it does it to a material that has multiple authors so its useless
        end          
        string :author, multiple: true do
          #self.bauthors.select_all(:lastname,:firstname)
          self.bauthors.pluck(:firstname,:lastname)
          #self.bauthors.collect(:firstname).collect(:name)
        end                
        
      end
      # :nocov:
    end
  end


  def remove_duplicate_external_resourcess
    # New resources have a `nil` created_at, doing this puts them at the end of the array.
    # Sorting them this way means that if there are duplicates, the oldest resource is preserved.
    resources = bauthors.to_a.sort_by { |x| x.created_at || 1.year.from_now }
    (resources - resources.uniq { |r| [r.firstname] }).each(&:mark_for_destruction)
  end
end
