# Fbpostscrapper

## Installation

Clone the repository
  
    $ git clone https://github.com/a-rmz/fb-scrapper.git

Install [Rethinkdb](https://rethinkdb.com/) and make sure the server is running.

Update modify the `config/database.yaml` according to your needs.

Install the dependencies
  
    $ bin/setup

Now, create a [facebook app](https://developers.facebook.com) and keep the app id and secret close.
Rename the `config/facebook.yaml.example` as `config/facebook.yaml`

    $ mv config/facebook.yaml.example config/facebook.yaml

and fill the required fields.

## Usage

    $ bin/console

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/a-rmz/fbpostscrapper.
