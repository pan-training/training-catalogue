## Changes

### Map

- When creating an event the user can create a marker at a certain place on the map through a text box with active autocompletion.

- When viewing an event that has a location the map appears centered on it. 

- Map index that shows all markers on the map. Centered on Europe. Can filter the results.


### Small changes

- Language field added.

- Counter on the home page indicating the number of Events, Materials and Workflows.

### BUG FIXES

- Marker image appearing at the bottom of the index map. Take it off. 
//DONE

- Check that the redis/Nil problem does not appear in production mode (see comments in the event model, geocoding_cache_lookup function).
//DONE. Added a condition that checks if Nil. 

- When using the previous button of the net browser, the js relating to the map breaks (look at rails turbolinks).
//DONE. Deactivated the turbolinks cache for certain pages to solve the problem. A better solution might exist, if so will be implemented at a later date. 

- Finding materials through the event creation page has stopped working, need to fix this.
//DONE. Linked to the Gemfile it seems. Specifically the versions of rails-assets-moment and rails-assets-devbridge-autocomplete. Weird.

- Nicer css for the marker popup. Example: on the index map, the popup has a link to the url of the event but the css needs to make it clear it's a link.
//DONE. Small css improvement.

### TODO

- If two (or more) events are located at the same place the popup text needs to show information for both (or more) of these events.
Will directly update the master branch when this improvement is done.
