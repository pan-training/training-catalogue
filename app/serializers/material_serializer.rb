class MaterialSerializer < ApplicationSerializer
  attributes :id, :title, :url, :short_description, :doi, :remote_updated_date, :remote_created_date, :keywords, :licence,
             :difficulty_level, :bcontributors, :bauthors, :target_audience, :scientific_topics,
             :external_resources, :created_at, :updated_at

  belongs_to :user
  belongs_to :content_provider
  has_many :nodes
end
