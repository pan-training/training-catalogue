
## Changes

### Materials: authors and contributors

Authors and contributors now have three input fields: firstname, lastname and orcid(optional).

orcid is also added as a field for users.

### PaNET ontology

The field 'Scientific topics' of Materials and Events now uses the PaNET ontology instead of the EDAM ontology tess-elixir used.

### User analytics (Ahoy, Blazer)

Ahoy is for tracking the users and blazer is a visualisation tool.

Go to /blazer to create queries (authorized for admins only). 
GDPR compliant.

The mapbox token needs to be inputed in the blazer.yml config file if maps are to be used.

Blazer query examples can be found in the blazer_queries.txt file. 

### Deletion of unused or broken fields

For Materials and Events the external resources field no longer has fairshare and tools suggestion boxes. Fairshare's is broken because the api changed (new version) and the tools are related to biology.

For Materials and Events, the operations field has been removed. It existed because of the EDAM ontology.

### Small bugs fixed and misc

External resources were not searchable by title through the search box, they now are. 

The json api (materials.json etc) only showed the last external resource, they are now all shown.

Dropdown menu for the header to resemble pan-learning's header.

(links) text added next to external resources to make it clearer that they are outgoing links.


### Migrations

run: 
```
rails db:migrate
```
To run the migrations. 

Then run: 
```
bundle exec rake dice:authorscontributors
```
to migrate old data (author and contributo fields of a material) to the new models (the author and contributor tables).

Then finally run:
```
rails g migration RemoveAuthorsandContributorsFromMaterials authors:string contributors:string
rails db:migrate
```

### TODO

#### Important

Need to create a rake task that migrates old data with old models (on the production site now) to the new models. (DONE)

Add the content provider's logo on the workflow's page if it has a content provider.

#### Not important

Might want to rename bcontributor and bauthor models as contributor and author in the code. The names of the models pop up in the error flash messages, might pop up elsewhere too.

Might want to do the above changes to the elearning pages. But we don't use them so might not.
