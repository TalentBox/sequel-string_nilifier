# Sequel::StringNilifier

Sequel plugin to convert empty string to nil

## Installation

Add this line to your application's Gemfile:

    gem 'sequel-string_nilifier'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sequel-string_nilifier

## Usage

```ruby
# Make all model subclass instances nilify strings (called before loading subclasses)
Sequel::Model.plugin :string_nilifier

# Make the Album class nilify strings
Album.plugin :string_nilifier
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
