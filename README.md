## Changes (readme in construction)

### Map

- When creating an event the user can create a marker at a certain place on the map through a text box with active autocompletion.

- When viewing an event that has a location the map appears centered on it. 

- Map index that shows all markers on the map. Centered on Europe. Can filter the results.


### Small changes

- Language field added.

- Counter on the home page indicating the number of Events, Materials and Workflows.

### TODO

- Marker image appearing at the bottom of the index map. Take it off.

- Check that the redis/Nil problem does not appear in production mode (see comments in the event model, geocoding_cache_lookup function).

- When using the previous button of the net browser, the js relating to the map breaks (look at rails turbolinks).

- Finding materials through the event creation page has stopped working, need to fix this.

- Nicer css for the marker popup. Example: on the index map, the popup has a link to the url of the event but the css needs to make it clear it's a link.

