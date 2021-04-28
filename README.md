# TeSS Trainning Catalogue at HZDR

## Setup

```
sudo apt-get install git postgresql libpq-dev imagemagick openjdk-8-jre nodejs redis-server
```

Clone the TeSS source code via git:

```
git clone https://github.com/ElixirTeSS/TeSS.git
```

### RVM, Ruby, Gems

It is typically recommended to install Ruby with RVM. With RVM, you can specify the version of Ruby you want installed, plus a whole lot more (e.g. gemsets). Full installation instructions for RVM are available online. In short:

```
sudo apt-get install software-properties-common

sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get install rvm

rvm user gemsets
```

TeSS was developed using Ruby 2.4.5 and we recommend using version 2.4.5 or higher. To install TeSS' current version of ruby and create a gemset, you can do something like the following:

```
rvm install `cat .ruby-version`
/bin/bash --login
rvm get stable --auto-dotfiles
rvm use --create `cat .ruby-version`@`cat .ruby-gemset`
```

Bundler provides a consistent environment for Ruby projects by tracking and installing the exact gems and versions that are needed for your Ruby application.

```
gem install bundler
```

### Redis/Sidekiq

We installed Redis before... but start Sidekiq!

```
bundle exec sidekiq
```

Note that program 'gem' (a package management framework for Ruby called RubyGems) gets installed when you install RVM so you do not have to install it separately.

Once you have Ruby, RVM and bundler installed, from the root folder of the app do:

```
bundle install
```

Follow the steps on the official GitHub and setup PostgrSQL [repo](https://github.com/ElixirTeSS/TeSS), Solr, ... In a first development instance is is necessary to add the database login information in `secrets.yml`. 

### Solr

TeSS uses Apache Solr to power its search and filtering system.

To start solr, run:

```
bundle exec rake sunspot:solr:start
```

You can replace start with stop or restart to stop or restart solr. You can use reindex to reindex all records.

```
bundle exec rake sunspot:solr:reindex
```

### Database and Config

From the app's root directory, create several config files by copying the example files.

```
cp config/tess.example.yml config/tess.yml

cp config/sunspot.example.yml config/sunspot.yml

cp config/secrets.example.yml config/secrets.yml
```

Create Postgres DB with user `tess_user` and edit `config/secrets.yml` to configure the database name, user and password defined before.

Edit `config/secrets.yml` to configure the app's secret_key_base which you can generate with:

```
bundle exec rake secret
```

Create the databases:

```
bundle exec rake db:create:all
```

Start Solr:

```
bundle exec rake sunspot:solr:start

bundle exec rake sunspot:solr:reindex
```

Create the database structure and load in seed data:

Note: Ensure you have started Solr before running this command!

```
$ bundle exec rake db:setup
```


### Dev Server

The dev server can evaluated with

```
bundle exec sidekiq
```

and

```
bundle exec rails server
```

and accessed via: http://localhost:3000

#### Setup Administrators

Once you have a local TeSS succesfully running, you may want to setup administrative users. To do this register a new account in TeSS through the registration page. Then go to the applications Rails console:

```
bundle exec rails c
```

Find the user and assign them the administrative role. This can be completed by running this (where myemail@domain.co is the email address you used to register with):

```
2.2.6 :001 > User.find_by_email('myemail@domain.co').update_attributes(role: Role.find_by_name('admin'))
```

## Deployment: Providing TeSS using an Application Server

After setting up TeSS, the configuration of an application server (**Phusion Passenger** is an application server and it is often used to power Ruby sites) is required.

Or my prefered setup with Nginx:

https://www.phusionpassenger.com/library/config/nginx/intro.html

We need additinal packages:

```
apt-get install apache2-dev apt-get install libcurl4-gnutls-dev
```

After successfull development deployment add the Passenger Gem with:

```
sudo apt-get install -y dirmngr gnupg
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo apt-get install -y apt-transport-https ca-certificates

# Add our APT repository
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update

# Install Passenger + Nginx module
sudo apt-get install -y libnginx-mod-http-passenger
```

Check the installation with:

```
sudo /usr/bin/passenger-config validate-install

sudo /usr/sbin/passenger-memory-stats
```

...and add the recommended lines to your Nginx configuration file and finish the Passenger setup.


```
server {
	# SSL configuration
	listen 443;
	ssl on;

	proxy_set_header X_FORWARDED_PROTO https;
              proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header  Host $http_host;
              proxy_set_header  X-Url-Scheme $scheme;
              proxy_redirect    off;
              proxy_max_temp_file_size 0;

	server_name pan-training.hzdr.de;

	ssl_certificate /etc/ssl/certs/pan.cert;
    ssl_certificate_key /etc/ssl/private/pan.key;

	ssl_session_timeout 1d;
    ssl_session_cache shared:MozSSL:10m;  # about 40000 sessions
    ssl_session_tickets off;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;

    root /var/www/catalogue/public;
    passenger_enabled on;
	passenger_ruby /usr/share/rvm/gems/ruby-2.4.5@tess/wrappers/ruby;
	passenger_document_root /var/www/catalogue/public/;
    passenger_sticky_sessions on; 
}
```

Then we need the production environment:

```
bundle exec rake db:setup RAILS_ENV=production
```

or clean init:

```
bundle exec rake db:reset RAILS_ENV=production
```
and reindex Solr:

```
bundle exec rake sunspot:solr:reindex RAILS_ENV=production
```

Create an admin user and assign it appropriate 'admin' role bu looking up that role in console in model Role (default roles should be created automatically).

The first time and each time a css or js file is updated:

```
bundle exec rake assets:clean RAILS_ENV=production

bundle exec rake assets:precompile RAILS_ENV=production
```