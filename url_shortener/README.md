# URL Shortener System

The URL shortener system allows users to convert long, cumbersome URLs into short, manageable links. By submitting a URL to the system, it generates a unique short URL that redirects to the original long URL when accessed.

The system also tracks the number of times each short URL is accessed, providing useful analytics for its users. Additionally, each short URL may have an expiration date, after which it becomes inactive and returns a "URL expired" message.

When a user accesses a short URL, the system checks if the URL is still valid (i.e., not expired). If valid, the system redirects the user to the original URL; otherwise, it returns a message indicating that the URL has either expired or does not exist.

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

## How to test using requests
First, create an User
```bash
rails c
```
```ruby
User.create! email: "user@example.com", "password": "123456"

```
Then, login.
```json
{
  "email": "user@example.com",
  "password": "123456"
}

```
Response:
```json
{
  "authentication_response": {
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NDI1NjA1NDd9.fmAoc0fk0jZ0V2rEaELOsOyDclBZoY3Y9mT6G3uFAV8",
    "user": {
      "id": 1,
      "email": "user@example.com"
    }
  }
}

```
Add token to Authorization Bearer. 
```bash
# Insomnia, for example

TOKEN: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NDI1NjA1NDd9.fmAoc0fk0jZ0V2rEaELOsOyDclBZoY3Y9mT6G3uFAV8

```

## API Rest

URL to query                   | Description
------------------------------ | ---------------------------
<code>POST</code> `/v1/login` | Login.
<code>DELETE</code> `/v1/logout` | Logout.
<code>GET</code> `/v1/urls/{short_url}` | Retrieve original URL.
<code>GET</code> `/v1/urls/{short_url}/accesses` | Retrieve access history for short URL.
<code>POST</code> `/v1/urls` | Create short URL.

## Example

**Request**

    POST /v1/login

**Body**

```json
{
  "email": "user@example.com",
  "password": "123456"
}

```

**Return**

```json
{
	"token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NDI1NjA1NDd9.fmAoc0fk0jZ0V2rEaELOsOyDclBZoY3Y9mT6G3uFAV8",
	"user": {
		"id": 1,
		"email": "user@example.com"
	}
}

```

**Request**

    DELETE /v1/logout

**Return**

<code>204</code>


**Request**

    GET /v1/urls/{short_url}

**Return**

<code>302</code>

**Request**

    GET /v1/urls/{short_url}/accesses

**Return**

``` json
{
  "accesses": [
    {
      "id": 0,
      "url_id": 0,
      "access_count": 0,
      "accessed_at": "2025-03-20T12:17:19.568Z",
      "created_at": "2025-03-20T12:17:19.568Z",
      "updated_at": "2025-03-20T12:17:19.568Z"
    }
  ]
}
```
**Request**

    POST /v1/urls/{short_url}

**Body**

``` json
{
  "original_url": "string"
}
```

**Return**

``` json
{
  "url": {
    "original_url": "string",
    "short_url": "string",
    "access_count": 0,
    "expiration_date": "2025-03-20T12:17:36.083Z",
    "created_at": "2025-03-20T12:17:36.083Z",
    "updated_at": "2025-03-20T12:17:36.083Z"
  }
}
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
