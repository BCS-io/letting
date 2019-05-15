require_relative '../../../lib/stage/extract'

RSpec.describe Extract, :stage do
  it 'warns about using the abstract class.' do
    expect { warn 'override match method' }.to output.to_stderr
    Extract.new(extracts: []).match 'x', 'y'
  end
end
