## Changes

### Likes

Likes implemented. 

### Share button

Share button implemented.

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

### Deliverable field

Added a deliverable field for materials (do the same for events?).

### Front page counter separating materials

The front page counter now distinguishes between E-learning moodle materials (from pan-learning) and other materials.

### Miscellaneous

Language field added to the .json pages and to the search facets.

Processing content check better fix (thanks to fbacall from tess).

Workflows now use the PaNET ontology too.

Small fix that makes the url checker work for external resources.

### TODO

When liking/starring a material and clicking on the browser's back/previous button, we are not taken back to the previous page.
