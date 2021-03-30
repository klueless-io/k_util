# K Util

> KUtil provides simple utility methods

As a Developer, I need simple utility helpers, to solve cross cutting issues and simplify common access methods

## Usage

### Sample Classes

#### Example

Some common examples

```ruby
puts KUtil.file.expand_path('file.rb', '/klue-less/xyz')
puts KUtil.file.pathname_absolute?('somepath/somefile.rb')
puts KUtil.file.pathname_absolute?('/somepath/somefile.rb')

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
