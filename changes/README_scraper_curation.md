## Changes

### Materials and events curation functionality added

Administrators now have access to a button that deletes and unscrapes a material/event. These unscraped materials/events can then be rescraped through two pages that list what has been unscraped.

### Slight security issue

The POST endpoints 'unscrapeds/check_exists and 'eventunscrapeds/check_exists' can be accessed by anyone. They should only be accessed by admins.
When the scraper scrapes, it should to send the POST request as an authentified user with the 'scraper_role'.
Non admin, non scraper users can therefore see what unscraped materials/events exist. Security wise there is no real threat but we might want to restrict access to these endpoints in the future.
