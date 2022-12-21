class StaticController < ApplicationController

  skip_before_action :authenticate_user!, :authenticate_user_from_token!

  def privacy; end

  def create; end

  def home
    @hide_search_box = true
    @resources = []
    if TeSS::Config.solr_enabled
      [Event, Material].each do |resource|
        @resources += resource.search_and_filter(nil, '', sort_by: 'new', per_page: 2).results
      end
    end

    @resources = @resources.sort_by(&:created_at).reverse
  end
end
