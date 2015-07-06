require_relative 'test_helper'

class EventStreamTest < Minitest::Should::TestCase

  def pub_sub(name, attrs = {}, filter = nil)
    event = nil
    EventStream.subscribe(filter) do |e|
      event = e
    end
    EventStream.publish(name, attrs)
    event
  end

  teardown do
    EventStream.default_stream.clear_subscribers
  end

  context 'an event stream' do
    should 'publish an event and allow a subscriber to consume it' do
      event = pub_sub(:test)
      assert event
      assert_equal :test, event.name
    end

    should 'expose all event attributes to the subscriber' do
      event = pub_sub(:test, :x => 1)
      assert_equal 1, event.x
    end

    context 'filtering events' do
      should 'allow subscription to event names' do
        assert pub_sub(:test, {}, :test)
        refute pub_sub(:test, {}, :other_name)
      end

      should 'allow subscription to event names by regex' do
        assert pub_sub(:test_event, {}, /test/)
        refute pub_sub(:test_event, {}, /no_match/)
      end

      should 'allow subscription by event attributes' do
        assert pub_sub(:test, { :x => 1, :y => :attr}, :y => :attr)
        refute pub_sub(:test, { :x => 1, :y => :other}, :y => :attr)
      end

      should 'allow subscription via arbitrary predicate' do
        predicate = lambda { |e| e.x > 1 }
        assert pub_sub(:test, { :x => 2, :y => :attr}, predicate)
        refute pub_sub(:test, { :x => 1, :y => :attr}, predicate)
      end

    end
  end
end
