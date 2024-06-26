# MontaAPI

This is a Monta API wrapper gem to perform CRUD actions to the following resources:
- ReturnForecast
- ReturnLabel
- Return

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'monta_api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install monta_api

## Usage

### Client

On Monta dashboard, first connect to Monta's REST API and then add a new connection to get your
username and password

```ruby
client = MontaAPI::Client.new(username: monta_username, password: monta_password)
```

### Return

#### 1. Retrieve returns that were updated since a date

```ruby
client.return.where(since: "2024-04-05")

# => returns an array of MontaAPI::Return objects
```

### Return Forecast

#### 1. Retrieve a ReturnForecast by code

```ruby
client.return_forecast.find_by(code: "2")

# => returns a MontaAPI::ReturnForecast object
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/monta_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/monta_api/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MontaApi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/monta_api/blob/main/CODE_OF_CONDUCT.md).
