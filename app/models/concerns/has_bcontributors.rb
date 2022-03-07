module HasBcontributors

  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :bcontributors
    accepts_nested_attributes_for :bcontributors, allow_destroy: true
    #before_validation :remove_duplicate_external_resourcess

    if TeSS::Config.solr_enabled
      # :nocov:
      searchable do
        #need the text not just string otherwise the search through materials wont work...
        text :firstname_contributor do
          self.bcontributors.collect(&:firstname)
        end
        string :firstname_contributor, multiple: true do
          self.bcontributors.collect(&:firstname)
        end
        
        text :lastname_contributor do
          self.bcontributors.collect(&:lastname) 
        end        
        string :lastname_contributor, multiple: true do
          self.bcontributors.collect(&:lastname)
        end
        

        text :contributor do
          #self.bcontributors.pluck(:firstname,:lastname)
          self.bcontributors.pluck(:firstname,:lastname).to_s
        end          
        string :contributor, multiple: true do
          #self.bcontributors.pluck(:firstname,:lastname)
          arrayy = []
          bcontribs = self.bcontributors.pluck(:firstname,:lastname)
          bcontribs.each do |item|
          arrayy << item.to_s
          end          
          arrayy         
        end                
        
      end
      # :nocov:
    end
  end


  #def remove_duplicate_external_resourcess
    # New resources have a `nil` created_at, doing this puts them at the end of the array.
    # Sorting them this way means that if there are duplicates, the oldest resource is preserved.
    #resources = bauthors.to_a.sort_by { |x| x.created_at || 1.year.from_now }
    #(resources - resources.uniq { |r| [r.firstname] }).each(&:mark_for_destruction)
  #end
end

