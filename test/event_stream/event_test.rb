require_relative '../test_helper'

module EventStream
  class EventTest < Minitest::Should::TestCase

    context 'an event' do

      context 'creating and accessing values' do
        should 'exposed values passed in as a hash' do
          event = Event.new(a: 1, b: 2)
          assert_equal 1, event.a
          assert_equal 2, event.b
        end

        should 'expose values passed in as string keys' do
          event = Event.new('a' => 1, b: 2)
          assert_equal 1, event.a
        end

        should 'properly respond to existing (but not nonexisting) values' do
          event = Event.new('a' => 1, b: 2)
          assert event.respond_to?(:a)
          assert event.respond_to?(:b)
          refute event.respond_to?(:c)
        end
      end

      context '#to_json' do
        should 'serialize to json' do
          event = Event.new(a: 1, b: 2)
          assert_equal '{"a":1,"b":2}', event.to_json
        end
      end

      context '#from_json' do
        should 'deserialize from json' do
          json = '{"a":1,"b":2}'
          event = Event.from_json(json)
          assert_equal 1, event.a
          assert_equal 2, event.b
        end

        should 'raise an error if json is not valid' do
          assert_raises(JSON::ParserError) { Event.from_json('not valid') }
        end
      end
    end
  end
end
