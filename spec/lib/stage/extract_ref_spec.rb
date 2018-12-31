require_relative '../../../lib/stage/extract_ref'

RSpec.describe ExtractRef, :stage do
  def row human_ref: 10, value: 4
    { human_ref: human_ref, value: value }
  end

  it 'does not delete when different' do
    input = [row(human_ref: 10, value: 4)]
    extract = ExtractRef.new extracts: [row(human_ref: 20, value: 8)]
    extract.cleanse originals: input
    expect(input).to eq [row(human_ref: 10, value: 4)]
  end

  it 'deletes when id match' do
    input = [row(human_ref: 10, value: 4)]
    extract = ExtractRef.new \
      extracts: [row(human_ref: 10, value: 8)]
    extract.cleanse originals: input
    expect(input).to eq []
  end
end
