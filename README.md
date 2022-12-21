The user can upload directly to Zenodo through the training catalogue.

This repository contains the sourcecode of our [PaN Training Catalogue](https://pan-training.eu). This catalogue is based on the [TeSS Trainning Catalogue](https://github.com/ElixirTeSS/TeSS) from the [ELIXIR](https://elixir-europe.org) project and is used in our Photon and Neutron (PaN) projects [ExPaNDS](https://expands.eu) and [PaNOSC](https://panosc.eu).
 
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

TeSS was developed using Ruby 2.4.5. We recommend using version 2.7.4 for our PaN catalague. To install recommended version of ruby and create a gemset, you can do something like the following:

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

...or as a daemon in the background for production:

```
bundle exec sidekiq -d -L log/sidekiq.log -e production
```

Note that program 'gem' (a package management framework for Ruby called RubyGems) gets installed when you install RVM so you do not have to install it separately.

Once you have Ruby, RVM and bundler installed, from the root folder of the app do:

```
bundle install
```

Follow the steps on the official GitHub and setup PostgrSQL [repo](https://github.com/ElixirTeSS/TeSS), Solr, ... In a first development instance is is necessary to add the database login information in `secrets.yml`. 

### Set up environment

`bin/rails db:environment:set RAILS_ENV=development or production!!!`

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


### Small todos:

- Fix a size limit for the file.  

- Tiny detail but the new version (pseudo)button slightly changes colour when the mouse hovers over it when disabled. Make it not.


### Big todos:

- Check the text and the description before an upload to make sure it isn't spam.

- Take into account the success/failure codes zenodo's api sends back. Properly catch all the possible errors/failures. And in general try to catch other possible errors (when calling split on a potential nil(due to an error of some kind) value for example).

### In the near(ish) future:

- Finish oauth2 implementation (todo: facet search bars including both Zenodo materials and materials results, refresh token logic).

### Refactorisation to do at a later date:

- Quite a lot of repetition in the code, make it DRYer.


