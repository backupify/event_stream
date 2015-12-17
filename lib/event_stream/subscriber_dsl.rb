require 'active_support/concern'
require 'active_support/core_ext/class/attribute'

module EventStream
  # Provides a DSL with which to create Subscribers.
  # For example:
  #
  #    class MySubscriber
  #      include EventStream::SubscriberDSL
  #
  #      # Which event_stream to use. If not specified, the default will be used.
  #      event_stream EventStream.default_stream
  #
  #      # Sets up a subscriber using a block
  #      on(:my_other_event) { |event| puts event.name }
  #    end
  #
  # Note that this does NOT register subscribers. To register subscribers, call:
  #
  #     MySubscriber.subscribe
  #
  # This registers all subscribers to the provided event_stream (or to the default).
  #
  module SubscriberDSL
    extend ActiveSupport::Concern

    included do
      class_attribute :_event_subscribers
      class_attribute :_event_stream
      attr_reader :event
      self._event_subscribers = []
      self._event_stream = EventStream.default_stream
    end

    module ClassMethods
      def event_stream(event_stream)
        self._event_stream = event_stream
      end

      def on(filter, &action)
        self._event_subscribers << Subscriber.create(filter, &action)
      end

      def subscribe
        _event_subscribers.each { |subscriber| _event_stream.add_subscriber(subscriber) }
      end
    end
  end
end
