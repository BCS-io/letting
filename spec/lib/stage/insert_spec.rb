require_relative '../../../lib/stage/insert'

RSpec.describe Insert, :stage do
  it 'warns about using the abstract class.' do
    expect { warn 'override match method' }.to output.to_stderr
    Insert.new(insert: []).sort []
  end
end
