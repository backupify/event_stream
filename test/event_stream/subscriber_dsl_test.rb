require_relative '../test_helper'

module EventStream
  class SubscriberDSLTest < Minitest::Should::TestCase

    class MySubscriber
      include SubscriberDSL

      class << self
        attr_accessor :events
      end

      on(:event) { |event| self.events << event  }

      def a_method(event)
        self.class.events << event
      end
    end

    context 'The Subscriber DSL' do
      setup do
        MySubscriber.events = []
      end

      context 'the default stream' do
        setup do
          EventStream.clear_subscribers
          MySubscriber.event_stream(EventStream.default_stream)
          MySubscriber.subscribe
        end

        should 'handle a published event' do
          EventStream.publish(:event, test: true)
          assert_equal 1, MySubscriber.events.count
        end
      end

      context 'other event streams' do
        setup do
          @stream = EventStream::Stream.new
          MySubscriber.event_stream(@stream)

          @stream.clear_subscribers
          MySubscriber.subscribe
        end

        should 'handle a published event' do
          @stream.publish(:event, test: true)
          assert_equal 1, MySubscriber.events.count
        end
      end
    end
  end
end
