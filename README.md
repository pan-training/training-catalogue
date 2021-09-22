## Integration of the api client gem

 
### tess_api_client gem integration

Changed the bootsnap version to ">= 1.4.6". See https://github.com/rails/rails/issues/36970

Created the "my_upload_script.rb" and the configuration file "uploader_config.txt"
Need to put in the config file the user token and mail. 
Can be found through the rails app on the user page (bottom left of the page).

Also:

```
chmod 755 my_upload_script.rb
```

Added the tess_api_client to the Gemfile.
Then: 

```
sudo -E bundle install
```

When doing:

```
gem list
```

The tess_api_client gem should be visible.

If it isn't, see where the gem gets installed.

```
bundle info tess_api_client
```

Here for example "/var/lib/gems/2.7.0/bundler/gems/"  

Go there and:

```
sudo -E gem build tess_api_client.gemspec
```

then

```
sudo -E gem install tess_api_client
```

Check with gem list that it is installed.

### moodle scraper proof of concept

Created the "moodle_scraper.rb" file
Need to put in the file the token that moodle generated for webservices.

Also:

```
chmod 755 moodle_scraper.rb
```

To run the scripts just 

```
ruby name_of_script.rb
```


