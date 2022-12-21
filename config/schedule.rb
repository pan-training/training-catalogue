# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :environment, "production" 

# Generate a new sitemap...
every 1.day, at: "5am" do
#every 2.minutes do
  rake "sitemap:generate"
end

every 1.day, at: "6am" do
  rake "tess:check_material_urls"
end

every 1.day, at: "7am" do
  rake "tess:check_event_urls"
end

every 1.day, at: "8am" do
  #bundle exec rake sunspot:solr:reindex
  rake "sunspot:solr:reindex"
end

every 1.day, at: "8am" do
  rake "tess:process_subscriptions"
end

every 1.day, at: '12:30 pm' do
  command '/opt/catalogue_scrapers/scraper.job'
end