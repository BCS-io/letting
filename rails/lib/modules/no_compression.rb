####
#
# A class that can be used in production to remove
# compression from minified js code if you need to
# do debugging.
#
####
#
class NoCompression
  def compress string
    # do nothing
    string
  end
end
