require 'forwardable'

module Hayrick
  class FilterRepository
    extend Forwardable
    def_delegators :all, :[], :merge!

    attr_reader :default_filter

    def initialize(default_filter = DefaultFilterGenerator.new)
      @default_filter = default_filter
    end

    def add(name, callable)
      prepare_callable(callable).tap do |prepared_callable|
        merge!(name.to_sym => prepared_callable)
      end
    end

    def all
      @filters ||= Hash.new do |_, keyword|
        default_filter.call(keyword)
      end
    end

    private

    def prepare_callable(callable)
      case(callable)
      when Proc then callable
      when CallableClass then callable.new.method(:call)
      else fail(ArgumentError, 'Invalid filter provided.')
      end
    end

    CallableClass = lambda do |klass|
      klass.is_a?(Class) && klass.instance_methods.include?(:call)
    end

    private_constant :CallableClass
  end
end
