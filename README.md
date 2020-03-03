# Roko

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/roko`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'roko'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install roko

### Authenticate each services

Service | environment variable | description
:-- | :-- | :-- 
Github | `NETRC_FILE_PATH` | Path for netrc file.
Google Calendar | `GOOGLE_API_CREDENTIALS_PATH` | Path for google api credentials file.
Slack | `SLACK_API_TOKEN` | Slack API token.
Confluence | `CONFLUENCE_USER`<br>`CONFLUENCE_PASSWORD`<br>`CONFLUENCE_URL`  | User and password for confluence.

#### Github

Write netrc file like below.

```
machine api.github.com
  login your_username
  password password_or_your_api_token
```

Set the netrc file's path imn environment variable `NETRC_FILE_PATH`.
Or use `~/.netrc` by default.

#### Google Calendar

Create your service account and download a credential file.

see: https://cloud.google.com/docs/authentication/getting-started?hl=en

Set the credential file's path in environment variable `GOOGLE_API_CREDENTIALS_PATH`.
Or use `~/credentials.json` by default.

#### Slack

Set your slack API access token as environment variable `SLACK_API_TOKEN`.

#### Confluence

Set your user name and password as environment variable `CONFLUENCE_USER`, `CONFLUENCE_PASSWORD`.

This gem access `CONFLUENCE_URL` as confluence host.

## Usage

```
$ bundle exec ruby exec/roko help
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hmiyado/roko.

