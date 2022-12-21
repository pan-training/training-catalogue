class Like < ApplicationRecord
  belongs_to :user
  belongs_to :resource, polymorphic: true
  validates :resource_id, presence: true, uniqueness: { scope: [:resource_type, :user_id] }

  
  after_save :reindex_like
  after_destroy :reindex_like

  private

  def reindex_like
    Sunspot.index(resource) if TeSS::Config.solr_enabled
  end  

end
