require_relative '../test_helper'
require 'event_stream/test_helper'

module EventStream
  class TestHelperTest < Minitest::Should::TestCase
    include Assertions

    setup do
      Assertions.setup_test_subscription
    end

    context '#assert_event_published' do
      should 'raise no error when an event has been published' do
        EventStream.publish(:test_event)
        assert_event_published(:test_event)
      end

      should 'raise an error if the event has not been published' do
        assert_raises(Minitest::Assertion) { assert_event_published(:test_event) }
      end
    end

    context 'registering the test subscription' do
      should 'not register multiple subscriptions' do
        assert_equal 1, EventStream.default_stream.subscribers.length
      end
    end

    context '#find_published_event' do
      should 'find an event if one is present' do
        EventStream.publish(:test_event, key: :val)
        assert find_published_event { |evt| evt.key == :val }
      end

      should 'not find an event if it does not match' do
        EventStream.publish(:test_event, key: :other)
        refute find_published_event { |evt| evt.key == :val }
      end
    end
  end
end
