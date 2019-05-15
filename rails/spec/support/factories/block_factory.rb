def block_factory **args
  block = Block.new id: args[:id], name: args[:name]
  block.save!
  block
end
