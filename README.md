# EventStream

A minimal library for synchronously publishing and subscribing to events.

## Usage

Create an event subscription:

```ruby
EventStream.subscribe(:my_event) do |event|
  log("#{event.name}, #{event.description}")
end
```
Then fire an event:

```ruby
EventStream.publish(:my_event, :description => "An example event.")
```

An event is just an OpenStruct with a name and a bundle of other attributes, so the use of `:description` here is arbitrary.

Events can be subscribed to by name, as above, but many other ways are supported:

```ruby
# Subscribe to all events
EventStream.subscribe { |e| ... }

# Subscribe to events with a given name
EventStream.subscribe(:my_event) { |e| ... }

# Subscribe to events based on a name regex
EventStream.subscribe(/my/) { |e| ... }

# Subscribe to events based on their attributes
EventStream.subscribe(:user_id => 1) { |e| ... }

# Subscribe to events based on an arbitrary filter
filter = lambda { |e| e.size > 3 }
EventStream.subscribe(filter) { |e| ... }
```

### Event Streams

If you wish, you may create more than one event stream:

```ruby
stream = EventStream::Stream.new
stream.subscribe(...) { |e| ... }
stream.publish(...)
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'event_stream', :git => 'git@github.com:backupify/event_stream.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install event_stream
