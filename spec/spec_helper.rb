require 'rubygems'
require 'bundler/setup'
# our gem
require 'sm_archivator'

RSpec.configure do |config|
  config.failure_color = :red
  config.tty = true
  config.color = true
end