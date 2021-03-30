# K Util

> KUtil provides simple utility methods

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'k_util'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install k_util
```

## Stories

### Main Story

As a Developer, I need simple utility helpers, to solve cross cutting issues and simplify common access methods

See all [stories](./STORIES.md)

## Usage

See all [usage examples](./USAGE.md)

### Basic Example

#### Console Helpers

Generate encoded strings that have meaning in the console

```ruby
puts KUtil.console.hyperlink('Google', 'https://google.com')

# "Google"
# (clickable hyperlink to the google website)

puts KUtil.console.file_hyperlink('My File', '/somepath/my-file.txt')

# "My File"
# (clickable link to the a file in the file system)
```

#### File Helpers

```ruby
puts KUtil.file.expand_path('file.rb')

# /current/folder/file.rb

puts KUtil.file.expand_path('/file.rb')

# /file.rb

puts KUtil.file.expand_path('~/file.rb')

# /Users/current-user/file.rb

puts KUtil.file.expand_path('file.rb', '/klue-less/xyz')

# /klue-less/xyz/file.rb

puts KUtil.file.pathname_absolute?('somepath/somefile.rb')

# false

puts KUtil.file.pathname_absolute?('/somepath/somefile.rb')

# true
```

## Development

Checkout the repo

```bash
git clone klueless-io/k_util
```

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

```bash
bin/console

Aaa::Bbb::Program.execute()
# => ""
```

`k_util` is setup with Guard, run `guard`, this will watch development file changes and run tests automatically, if successful, it will then run rubocop for style quality.

To release a new version, update the version number in `version.rb`, build the gem and push the `.gem` file to [rubygems.org](https://rubygems.org).

```bash
rake publish
rake clean
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/klueless-io/k_util. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the K Util project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/klueless-io/k_util/blob/master/CODE_OF_CONDUCT.md).

## Copyright

Copyright (c) David Cruwys. See [MIT License](LICENSE.txt) for further details.
