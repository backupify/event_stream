require 'json'

module EventStream
  # Events are immutable collections of fields with convenience methods for accessing and json serialization
  class Event

    # @param fields [Hash<Symbol, Object>] The attributes of this event
    def initialize(fields)
      @fields = Hash[fields.map { |k,v| [k.to_sym, v] }].freeze
    end

    # An alternate field accessor
    # @param key [Symbol]
    # @return [Object]
    def [](key)
      @fields[key.to_sym]
    end

    # @return [Hash<Symbol, Object>]
    def to_h
      @fields
    end

    # @return [String]
    def to_json
      JSON.dump(to_h)
    end

    # Parses an event object from JSON
    # @param json_event [String] The JSON event representation, such as created by `event.to_json`
    # @return [Event]
    def self.from_json(json_event)
      new(JSON.parse(json_event))
    end

    def method_missing(method_name, *args)
      @fields.has_key?(method_name) ? @fields[method_name] : super
    end

    def respond_to_missing?(method_name, include_private = false)
      @fields.has_key?(method_name) || super
    end
  end
end
