require_relative '../../../lib/stage/patch'

RSpec.describe Patch, :stage do
  it 'warns about using the abstract class.' do
    expect { warn 'override match method' }.to output.to_stderr
    Patch.new(patch: []).match 'x', 'y'
  end
end
