require 'rubygems'
require 'pry'
require 'minitest/autorun'
require 'minitest/should'


require 'event_stream'

class Minitest::Should::TestCase
  def self.xshould(*args)
    puts "Disabled test: #{args}"
  end
end
