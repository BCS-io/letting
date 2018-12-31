require_relative '../../../lib/stage/stage'
require_relative '../../../lib/stage/patch_ref'
require_relative '../../../lib/stage/extract_ref'
require_relative '../../../lib/csv/csv_transform'

RSpec.describe Stage, :stage do
  describe 'initialize' do
    describe 'headers' do
      it 'can be set directly' do
        stage = Stage.new file_name: 'blah.csv',
                          input: [{ human_ref: 1, other: 'world' }],
                          instructions: [{ human_ref: 2, other: 'word' }],
                          headers: ['hello']

        expect(stage.headers).to eq ['hello']
      end

      it 'can be set through input' do
        stage =  Stage.new file_name: 'blah.csv',
                           input: test_items,
                           instructions: [{ human_ref: 2, other: 'word' }]

        expect(stage.headers).to eq ['hello']
      end

      def test_items
        DB::CSVTransform.new \
          file_name: 'spec/fixtures/import_data/open_test.csv',
          headers: ['hello']
      end
    end
  end

  describe 'full tests'
  it 'patches' do
    patch = PatchRef.new patch: [{ human_ref: 1, other: 'word' }]
    ref = Stage.new file_name: 'blah.csv',
                    input: [{ human_ref: 1, other: 'world' }],
                    instructions: [patch],
                    headers: ['hello']
    expect(ref).to receive(:stage_array)
      .with rows: [{ human_ref: 1, other: 'word' }]
    ref.stage
  end

  it 'extracts' do
    extract = ExtractRef.new extracts: [{ human_ref: 1 }]
    ref = Stage.new file_name: 'blah.csv',
                    input: [{ human_ref: 1, other: 'world' }],
                    instructions: [extract],
                    headers: ['hello']
    expect(ref).to receive(:stage_array).with rows: []
    ref.stage
  end

  it 'completes full test multiple instruction' do
    patch = PatchRef.new patch: [{ human_ref: 1, other: 'word' }]
    extract = ExtractRef.new extracts: [{ human_ref: 2 }]
    ref = Stage.new file_name: 'blah.csv',
                    input: [{ human_ref: 1, other: 'world' },
                            { human_ref: 2, other: 'world' }],
                    instructions: [patch, extract],
                    headers: ['hello']
    expect(ref).to receive(:stage_array)
      .with rows: [{ human_ref: 1, other: 'word' }]
    ref.stage
  end
end
