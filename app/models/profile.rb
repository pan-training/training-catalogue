class Profile < ApplicationRecord
  belongs_to :user, inverse_of: :profile
  validates :orcid, length: {is: 19}, allow_blank: true
=begin
  extend FriendlyId
  friendly_id [:firstname, :surname], use: :slugged
=end

  if TeSS::Config.solr_enabled
    # :nocov:
    searchable do
      text :firstname
      text :surname
      text :website
      text :orcid
      text :email
      text :image_url
      time :updated_at
    end
    # :nocov:
  end

  #validates :email, presence: true

  def full_name
    "#{firstname} #{surname}".strip
  end
end
