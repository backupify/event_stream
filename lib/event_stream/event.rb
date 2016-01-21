module EventStream
  # An Event. Each event is an OpenStruct with a name as well as any number of other optional fields.
  # @!attribute name
  # @return [Symbol]
  class Event < OpenStruct; end
end
