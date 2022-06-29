## Changes (ongoing)

Changes are ongoing, mainly: 
like button, share button, 404 url checker fixed, tess bug where stars dont get deleted if the material gets deleted and misc.

### Likes

Likes implemented. 

### Share button

Share button implemented. Still needs to be tested on the respective social platforms.

### Star bug fix

When a user starred a material (or other), and then deleted that material, and went to see his starred materials nothing would appear.
The dependent destroy relationship did not work. When one material was deleted, it's likes weren't deleted too. 
Now it is fixed.

### Url checker

To run the url checker for materials: 

`bundle exec rake tess:check_material_urls`

and for events: 

`bundle exec rake tess:check_event_urls` 

To do it once a day you can add to the /config/schedule.rb file: 

```
every 1.day, at: "11am" do
  rake "tess:check_material_urls"
end
```

Solr needs to be reindexed after. Either do it manually or periodically.

After reindexing the materials/events with broken links are hidden and do not show up in the search anymore.

manually:

`bundle exec rake sunspot:solr:reindex`

/config/schedule.rb:

```
every 1.day do
  rake "sunspot:solr:reindex"
end
```

Then to update the cron job:

`bundle exec whenever -w`

The rest will be done progressively and this README will be updated.

Another different branch will be created for the zenodo seamless upload at a later date.
