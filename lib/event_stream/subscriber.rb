module EventStream
  class Subscriber < Struct.new(:filter, :action)
    def self.create(filter = nil, &action)
      filter ||= lambda { |e| true }
      filter_predicate = case filter
                         when Symbol, String then lambda { |e| e.name.to_s == filter.to_s }
                         when Regexp then lambda { |e| e.name =~ filter }
                         when Hash then lambda { |e| filter.all? { |k,v| e[k] === v } }
                         else filter
                         end
      new(filter_predicate, action)
    end

    def consume(event)
      action.call(event) if filter.call(event)
    end
  end
end
