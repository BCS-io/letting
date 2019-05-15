# MatchDueOn
#
# spot - the date which something became due
# show - the date we display as the date it became due - when the spot date
#        is not acceptable.
#
MatchedDueOn = Struct.new(:spot, :show) do
  def <=> other
    return nil unless other.is_a?(self.class)

    [spot, show] <=> [other.spot, other.show]
  end
end
