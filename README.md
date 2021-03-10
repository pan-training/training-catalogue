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

Install Solr as described [here](https://tecadmin.net/install-apache-solr-on-ubuntu/):

```
sudo apt install openjdk-11-jdk

cd /opt
wget https://archive.apache.org/dist/lucene/solr/8.5.2/solr-8.5.2.tgz
tar xzf solr-8.5.2.tgz solr-8.5.2/bin/install_solr_service.sh --strip-components=2
sudo bash ./install_solr_service.sh solr-8.5.2.tgz
```

The Admin Panel: http://vlsrdm.fz-rossendorf.de:8983

### Database and Config

From the app's root directory, create several config files by copying the example files.

```
$ cp config/tess.example.yml config/tess.yml

$ cp config/sunspot.example.yml config/sunspot.yml

$ cp config/secrets.example.yml config/secrets.yml
```

Create Postgres DB with user `tess_user` and edit `config/secrets.yml` to configure the database name, user and password defined before.

Edit `config/secrets.yml` to configure the app's secret_key_base which you can generate with:

```
$ bundle exec rake secret
```

Create the databases:

```
$ bundle exec rake db:create:all
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
$ bundle exec rails c
```

Find the user and assign them the administrative role. This can be completed by running this (where myemail@domain.co is the email address you used to register with):

```
2.2.6 :001 > User.find_by_email('myemail@domain.co').update_attributes(role: Role.find_by_name('admin'))
```

## Deployment: Providing TeSS using an Application Server

After setting up TeSS, the configuration of an application server (**Phusion Passenger** is an application server and it is often used to power Ruby sites) is required as described [here](https://www.digitalocean.com/community/tutorials/how-to-setup-a-rails-4-app-with-apache-and-passenger-on-centos-6) in a more general way.

We need additinal packages:

```
apt-get install apache2-dev apt-get install libcurl4-gnutls-dev
```

After successfull development deployment add the Passenger Gem with:

```
gem install passenger
passenger-install-apache2-module
```

...and add the recommended lines to your Apache configuration file and finish the Passenger setup.

Add site information at `/etc/apache2/sites-available/000-default.conf`:

```
<VirtualHost *:80>
	# The ServerName directive sets the request scheme, hostname and port that
	# the server uses to identify itself. This is used when creating
	# redirection URLs. In the context of virtual hosts, the ServerName
	# specifies what hostname must appear in the request's Host: header to
	# match this virtual host. For the default virtual host (this file) this
	# value is not decisive as it is used as a last resort host regardless.
	# However, you must set it for any further virtual host explicitly.
	#ServerName www.example.com

	ServerAdmin webmaster@localhost

	ServerName vlsrdm.fz-rossendorf.de
	# !!! Be sure to point DocumentRoot to 'public'! 
	DocumentRoot /var/www/html/tess/public 
	<Directory /var/www/html/tess/public> 
	# This relaxes Apache security settings. 
	AllowOverride all 
	# MultiViews must be turned off. 
	Options -MultiViews 
	</Directory> 

	# Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
	# error, crit, alert, emerg.
	# It is also possible to configure the loglevel for particular
	# modules, e.g.
	#LogLevel info ssl:warn

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

	# For most configuration files from conf-available/, which are
	# enabled or disabled at a global level, it is possible to
	# include a line for only one particular virtual host. For example the
	# following line enables the CGI configuration for this host only
	# after it has been globally disabled with "a2disconf".
	#Include conf-available/serve-cgi-bin.conf
</VirtualHost>

```

Then we need the production environment:

```
bundle exec rake db:setup RAILS_ENV=production
```

