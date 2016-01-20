require 'active_support/core_ext/class/attribute'

module EventStream
  class Registry

    class UnregisteredStream < StandardError; end

    class_attribute :streams
    self.streams = { default: Stream.new }

    def self.register(stream_name, stream)
      streams[stream_name] = stream
    end

    def self.lookup(stream_name)
      streams[stream_name] || (raise UnregisteredStream)
    end
  end
end
