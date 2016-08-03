require 'hayrick/version'
require 'hayrick/default_filter_generator'
require 'hayrick/filter_repository'

module Hayrick
  def self.included(base)
    base.send(:extend, ClassMethods)
  end

  def search(params, seed = base_scope)
    params.reduce(seed, &apply_filter)
  end

  def base_scope
    fail(NotImplementedError)
  end

  private

  def apply_filter
    lambda do |accumulated_search, (keyword, term)|
      lookup_filter(keyword).call(accumulated_search, term)
    end
  end

  def lookup_filter(name)
    self.class.search_filters[name]
  end

  module ClassMethods
    def filter(keyword, callable = nil, &block)
      (!!callable ^ !!block) || fail(ArgumentError)

      captured_callable = callable || block

      search_filters.add(keyword, captured_callable)
    end

    def search_filters
      @search_filters ||= FilterRepository.new
    end
  end
end
