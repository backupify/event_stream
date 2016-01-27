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

An event is just an immutable value object with a name and a bundle of other attributes, so the use of `:description` here is arbitrary.

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

### The Stream Registry

To allow for easy access to different streams from different call points, a registry is available for storing and
retrieving streams. To register a stream:

```ruby
stream = EventStream::Stream.new
EventStream.register_stream(:my_stream_name)
```

To access the stream from the registry and publish an event:

```ruby
EventStream[:my_stream_name].publish(...)
```

### Subscriber DSL

It's sometimes useful to separate the definition of a subscriber action
from the registration of the subscriber. The `SubscriberDSL` module
provides a way to do this.

Define a subscriber by mixing in the module:

```ruby
class MySubscriber
  include EventStream::SubscriberDSL

  # Which event_stream to use. If not specified, the default will be used.
  event_stream EventStream.default_stream

  # Sets up a subscriber using a block
  on(:my_event) { |event| puts event.name }
end
```

The definition of this class does NOT subscribe to any events. To subscribe
to the :my_event event, it is necessary to call `MySubscriber.subscribe`.

It is possible to use multiple `on` statements in a single class.
`MySubscriber.subscribe` will register all subscriptions.

## Application Testing

event_stream includes a test_helper module that provides some assertions, like `assert_event_published`. To use:
1. `require 'event_stream/test_helper'`
2. Call `EventStream::Assertions.setup_test_subscription` in the setup block of your tests
3. Include the `EventStream::Assertions` module where needed

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'event_stream', :git => 'git@github.com:backupify/event_stream.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install event_stream
