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
      merge!(name.to_sym => callable)
    end

    def all
      @filters ||= Hash.new do |_, keyword|
        default_filter.call(keyword)
      end
    end
  end
end
