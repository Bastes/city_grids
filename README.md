## Welcome to CityGrids

# Getting Started

Supposing you already:
* have installed the proper ruby version (as per Gemfile specification)
* have cloned this repository
* have installed a postgresql server and configured a user
* are typing commnds at your clone's root

1. Install the gems (using bundler):
  * install bundler (unless you've already got it):

    ```
    $ gem install bundler
    ```
  * install the gems:

    ```
    $ bundle install
    ```
2. Configure and create the database:
  * copy and edit the configuration file to your liking:

    ```
    $ cp config/database.yml.sample config/database.yml
    ```
  * set the database up:

    ```
    $ rake db:setup
    ```
3. Configure your environment configuration variables:
  * copy and edit the example configuration file:

    ```
    $ cp .env.sample .env
    ```
  * start the server using foreman (ctrl-c to stop)

    ```
    $ foreman start
    ```
4. There is no 4th step, you're up and running. Yoohoo ^^
5. There might be a 5th step though. If you want to read sent emails in dev
   mode as if you had sent and received them, you can install the mailcatcher
   gem and run it:
   ```
   $ gem install mailcatcher
   $ mailcatcher
   ```
   You can then see emails caught on http://localhost:1080
   This gem won't make it to the gemfile because the chances of conflicting
   with others are high and it isn't needed as a ruby dependency (it all talks
   through smtp). More infos on https://github.com/sj26/mailcatcher

# Running the specs

Is easy as:
```
$ rspec
```

And better, you can use guard to run them for you soon as you break something:
```
$ guard
```

Now you can break things.

# Boring licensing stuff

Can be found in the LICENSE.txt file. By the way, it's GPLV3, yay free software ^^
