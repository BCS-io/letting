#####
# SpaceOut
#
# Adds spaces evenly around search punctuation
#
#
class SpaceOut
  def self.process source
    remove_all_white_space(source.to_s).split('-').join(' - ')
                                       .split(',').join(', ')
  end

  def self.remove_all_white_space source
    source.gsub(/\s+/, '')
  end
end
