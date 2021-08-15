# Pokemon Simple REST API

# How to install

1. Make sure your ruby version is 2.7.3 (using rbenv to manage ruby versions)

```
rbenv install 2.7.3
```

2. Install the latest rails gem

```
gem install rails
```

3. Install PostgreSQL

for Linux

```
sudo apt install -y postgresql postgresql-contrib libpq-dev build-essential
sudo -u postgres psql --command "CREATE ROLE `whoami` LOGIN createdb;"
```

for Mac

```
brew install postgresql
brew services start postgresql
```

# How to start

## Local web server

_(Using the default Puma web server)_

1. Fork the repository from GitHub
2. Run `bundle install` to install all gems & dependencies
3. Run `rails db:create && rails db:migrate` to create and set the state of the Postgres DB instance
4. Run `rails server` to start the web server

## For testing

1. Run `rails db:test:prepare` to prepare the test database
2. Run `rails test` to run unit tests
3. Run `open coverage/index.html` (MacOS) or `xdg-open coverage/index.html` (Linux) to view unit test coverage stats

# How to update the pokemon list

Ideally this should be migrated to Sidekiq (or an alternative background job framework), but is currently run in console

1. Run `rails console`
2. Inside the console run `PokeApiImportService::ImportFullDataset.call(0.5)` - 0.5 is in seconds and is the number of seconds between requests to the remote API (in this case 2 requests per second)
3. This will fetch all pokemons and types from the Poke API

# API Documentation

## List of pokemons (endpoint)

_(quite brief)_

### `GET http://pokemons-simple-api.herokuapp.com/api/v1/pokemons`

```json
{
  "total_count": 1118,
  "next_page": true,
  "pokemon": [
    {
      "id": 1,
      "name": "bulbasaur",
      "types": [
        {
          "name": "grass"
        },
        {
          "name": "poison"
        }
      ]
    },
    {
      "id": 2,
      "name": "ivysaur",
      "types": [
        {
          "name": "grass"
        },
        {
          "name": "poison"
        }
      ]
    }
  ]
}
```

```
Name        | Type    | Description

success     | boolean | Indicates if query was successful or not

When successful:
pokemon     | list    | Contains a list of pokemon objects
total_count | integer | Total number of pokemon instances
next_page   | boolean | Indicates if there is a next page
id          | integer | Identifier
name        | string  | Name of pokemon
types       | list    | A list of type objects containing name as string

If error:
error       | string  | Contains error information

```

## Single pokemon (endpoint)

### `GET http://pokemons-simple-api.herokuapp.com/api/v1/pokemons/{id or name}/`

```json
{
  "pokemon": {
    "id": 1,
    "name": "bulbasaur",
    "types": [
      {
        "name": "grass"
      },
      {
        "name": "poison"
      }
    ],
    "poke_api_id": 1,
    "base_experience": 64,
    "height": 7,
    "is_default": true,
    "order": 1,
    "weight": 69
  },
  "success": true
}
```

```
Name            | Type    | Description

success         | boolean | Indicates if query was successful or not

If successful:
pokemon         | object  | Contains the information for a single pokemon
id              | integer | Identifier
name            | string  | Name of pokemon
types           | list    | A list of type objects containing name as string
poke_api_id     | integer | Identifier on Poke API
base_experience | integer | Base exp gained for defeating this Pokémon
height          | integer | Height in decimetres
is_default      | boolean | Default pokemon for each species
order           | integer | Order for sorting
weight          | integer | Weight in hectograms

If error:
error           | string  | Contains error information

```

Any error will return a 400 (Bad request) HTTP response code
