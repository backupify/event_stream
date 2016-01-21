require 'ostruct'
require_relative 'event_stream/event'
require_relative 'event_stream/stream'
require_relative 'event_stream/subscriber'
require_relative 'event_stream/registry'
require_relative 'event_stream/subscriber_dsl'

module EventStream
  class << self
    extend Forwardable

    # Returns the stream for a stream name from the stream registry.
    # @param stream_name [Symbol]
    # @return [Stream]
    def [](stream_name)
      Registry.lookup(stream_name)
    end

    # Registers a stream, associating it with a specific stream name
    # @param stream_name [Symbol]
    # @param stream [Stream]
    def register_stream(stream_name, stream)
      Registry.register(stream_name, stream)
    end

    # The default event stream
    # @return [Stream]
    def default_stream
      self[:default]
    end

    def_delegators :default_stream, :publish, :subscribe, :clear_subscribers
  end
end
