class ZenodomaterialSerializer < ApplicationSerializer
  attributes :id, :title, :url, :short_description, :doi, :remote_updated_date, :remote_created_date, :keywords, :zenodolicense,
             :bcontributors, :bauthors, :created_at, :updated_at

  belongs_to :user
  belongs_to :content_provider
end
