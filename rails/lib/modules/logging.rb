#
# Mixin to add Logging to a class
#
#
module Logging
  def logger
    Logging.logger
  end

  # Global, memorized, lazy initialized instance of a logger
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end
