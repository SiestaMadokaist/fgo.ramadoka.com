require 'memoist'
require 'fuzzystringmatch'
class FED
  FSM = FuzzyStringMatch::JaroWinkler.create(:native)
  extend Memoist
  attr_reader(:obj, :query, :block)
  def initialize(obj, query, &block)
    @obj = obj
    @query = query
    @block = block
  end

  def arg
    @block.call(@obj)
  end
  memoize(:arg)

  def distance
    FSM.getDistance(arg, @query)
    # Levenshtein.distance(arg, @query)
  end
  memoize(:distance)
end
