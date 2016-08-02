module Hayrick
  class DefaultFilterGenerator
    def call(name)
      -> (rel, value) { rel.where(name => value) }
    end
  end
end
