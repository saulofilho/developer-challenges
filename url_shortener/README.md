# URL Shortener System

The URL Shortener System is...

## Local development environment

Use `docker` and `docker compose` for development environment.

### Building and starting the container

Under the app folder execute the following commands:

```bash
docker compose up --build -d
```

### To access the container

Under the app folder execute the following commands:

```bash
docker compose exec api bash
```

## Test

```bash
rspec
```

## Lint

```bash
rubocop -A
```

## Generating documentation

```bash
rails rswag
```

## Console

```bash
rails c
```

## Gemfile

The lastest and greatest gems used are located at the [Gemfile](Gemfile).

It includes application gems like:

- [Postgres](https://github.com/ged/ruby-pg) for access to the Postgres database
- [Rack CORS](https://github.com/cyu/rack-cors) for control Cross-Site Resource Sharing
- [Rswag](https://github.com/rswag/rswag) for generate API specifications from RSpec examples

And develompent gems like:

- [Annotate](https://github.com/ctran/annotate_models) for summarizing the current schema
- [debase](https://github.com/ruby-debug/debase) for debug purpose
- [pry](https://github.com/pry/pry) for better dev console
- [rubocop](https://github.com/rubocop-hq/rubocop) for code analyzing and formatting
- [ruby-debug-ide](https://github.com/ruby-debug/ruby-debug-ide) for integrate to IDE debugger

And testing gems like:

- [Database Cleaner](https://github.com/DatabaseCleaner/database_cleaner) for cleaning database strategies
- [faker](https://github.com/faker-ruby/faker) for generating fake data
- [Rspec](https://github.com/rspec/rspec) for unit testing
- [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers) for common RSpec matchers
- [simplecov](https://github.com/simplecov-ruby/simplecov) for code coverage
- [pry-byebug](https://github.com/deivid-rodriguez/pry-byebug) for step-by-step debugging
- [awesome_print](https://github.com/awesome-print/awesome_print) for prints objects in full color
