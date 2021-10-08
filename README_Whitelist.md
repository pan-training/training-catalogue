## Email whitelist for the registration and workflow curation

 
### Email whitelist

The email whitelist is in app/models/user.rb at the line 284:

```
EMAIL_DOMAINS_RI = %w{egi.eu synchrotron-soleil.fr diamond.ac.uk ceric-eric.eu desy.de hzdr.de tessdefaultuser.com}
```

Simply add any email domain name that should be whitelisted. 

### Curators and workflows

Curators are now able to curate workflows.

### Sending emails in the production environment

Make an account on sendgrid.com to get your user_name and password.
Add this:

```
ActionMailer::Base.smtp_settings = {
  :user_name => 'apikey', # This is the string literal 'apikey', NOT the ID of your API key
  :password => '<SENDGRID_API_KEY>', # This is the secret sendgrid API key which was issued during API key creation
  :domain => 'yourdomain.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
```
to config/environments/production.rb
and comment out:

```
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.default_options = {from: 'admin@pan-training.hzdr.de'}
```

### Registration checkbox bug fixed

When the data consent checkbox was not checked a user could still create an account. It is no longer the case, the user has to check the checkbox.