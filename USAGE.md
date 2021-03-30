# K Util

> KUtil provides simple utility methods

As a Developer, I need simple utility helpers, to solve cross cutting issues and simplify common access methods

## Usage

### Sample Classes

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

#### Example

Some common examples

```ruby
# Expand Path

puts KUtil.file.expand_path('file.rb')

# /current/folder/file.rb

puts KUtil.file.expand_path('/file.rb')

# /file.rb

puts KUtil.file.expand_path('~/file.rb')

# /Users/current-user/file.rb

puts KUtil.file.expand_path('file.rb', '/klue-less/xyz')

# /klue-less/xyz/file.rb

# Absolute path/file name

puts KUtil.file.pathname_absolute?('somepath/somefile.rb')

# false

puts KUtil.file.pathname_absolute?('/somepath/somefile.rb')

# true
```
