require 'ostruct'

module EventStream
  class << self
    extend Forwardable

    # The default event stream
    # @return [Stream]
    def default_stream
      @default_stream ||= Stream.new
    end

    def_delegators :default_stream, :publish, :subscribe
  end

  # An Event. Each event is an OpenStruct with a name as well as any number of other optional fields.
  # @!attribute name
  #   @return [Symbol]
  class Event < OpenStruct; end

  class Stream
    def initialize
      @subscribers = []
    end

    # Publishes an event to this event stream
    # @param name [Symbol] name of this event
    # @param attrs [Hash] optional attributes representing this event
    def publish(name, attrs = {})
      e = Event.new(attrs.merge(:name => name))
      @subscribers.each { |l| l.consume(e) }
    end

    # Registers a subscriber to this event stream.
    # @param filter [Object] Filters which events this subscriber will consume.
    # If a string or regexp is provided, these will be matched against the event name.
    # A hash will be matched against the attributes of the event.
    # Or, any arbitrary predicate on events may be provided.
    # @yield [Event] action to perform when the event occurs.
    def subscribe(filter = nil, &action)
      filter ||= lambda { |e| true }
      filter_predicate = case filter
                         when Symbol, String then lambda { |e| e.name.to_s == filter.to_s }
                         when Regexp then lambda { |e| e.name =~ filter }
                         when Hash then lambda { |e| filter.all? { |k,v| e[k] === v } }
                         else filter
                         end
      @subscribers << Subscriber.new(filter_predicate, action)
    end

    # Clears all subscribers from this event stream.
    def clear_subscribers
      @subscribers = []
    end
  end

  # @private
  class Subscriber < Struct.new(:filter, :action)
    def consume(event)
      action.call(event) if filter.call(event)
    end
  end
end
