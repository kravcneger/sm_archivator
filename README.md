# SmArchivator

This gem is intended to compress data by the Huffman's algorithm. It works only with imitation binary streams that are made of '1' or '0' characters.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sm_archivator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sm_archivator

## Usage
  to compress:

    SmArchivator::compress('A message consists of charactres.') -> '1010101...'

  to expand:

    SmArchivator::expand('A Dummy binary stream 1010010101') -> String

## Contributing

1. Fork it ( https://github.com/[my-github-username]/sm_archivator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
