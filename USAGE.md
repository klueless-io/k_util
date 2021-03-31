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

#### File Helpers

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

#### Data Helpers

Data object helpers such as any object to open struct and any object to hash

```ruby
ThunderBirds = Struct.new(:action)

virgil =
  OpenStruct.new(
    name: 'Virgil Tracy', age: 73, thunder_bird: ThunderBirds.new(:are_grounded)
  )
penny =
  OpenStruct.new(
    name: 'Lady Penelope', age: 69, thunder_bird: ThunderBirds.new(:are_go)
  )

data = {
  key1: 'David',
  key2: 333,
  key3: ThunderBirds.new(:are_go),
  people: [virgil, penny]
}

data_open = KUtil.data.to_open_struct(data)
data_hash = KUtil.data.to_hash(data_open)

puts JSON.pretty_generate(data_hash)

# {
#   "key1": "David",
#   "key2": 333,
#   "key3": {
#     "action": "are_go"
#   },
#   "people": [
#     {
#       "name": "Virgil Tracy",
#       "age": 73,
#       "thunder_bird": {
#         "action": "are_grounded"
#       }
#     },
#     {
#       "name": "Lady Penelope",
#       "age": 69,
#       "thunder_bird": {
#         "action": "are_go"
#       }
#     }
#   ]
# }
```
