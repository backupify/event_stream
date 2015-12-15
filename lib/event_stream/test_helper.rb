module EventStream

  module TestEventStream
    class << self
      attr_accessor :events
    end
  end

  module Assertions
    def self.setup_test_subscription
      TestEventStream.events = []
      EventStream.subscribe(//) do |event|
        TestEventStream.events << event
      end
    end

    def assert_event_matching(message = nil, &predicate)
      if TestEventStream.events.nil?
        raise "Call EventStream::TestHelper.setup prior to using event_stream test assertions!"
      end

      assert TestEventStream.events.any?(&predicate), "Event stream did not include a matching event: #{message}"
    end

    def assert_event_published(event_name)
      assert_event_matching("No event with name #{event_name}") { |event| event.name == event_name }
    end

    def find_published_event(&predicate)
      TestEventStream.events.find(&predicate)
    end
  end
end
