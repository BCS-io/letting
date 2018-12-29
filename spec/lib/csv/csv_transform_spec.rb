require_relative '../../../lib/csv/csv_transform'

module DB
  describe CSVTransform, :import, :stage do
    describe 'to_a' do
      it 'errors if file unknown' do
        expect { warn 'Warning: client is missing.' }
          .to output.to_stderr
        CSVTransform.new file_name: 'client'
      end

      it 'opens valid file' do
        output = CSVTransform.new(file_name: file_name).to_a
        expect(output.length).to eq 1
      end
    end

    describe 'arguments' do
      it 'sets the file_name' do
        expect(CSVTransform.new(file_name: file_name).file_name)
          .to eq 'spec/fixtures/import_data/open_test.csv'
      end

      it 'drops rows' do
        output = CSVTransform.new(file_name: file_name,
                                  drop_rows: 1).to_a
        expect(output.length).to eq 1
      end

      it 'overwrites headers' do
        output = CSVTransform.new(headers: %w[one line],
                                  file_name: file_name).to_a
        output.each.first do |row|
          expect(row[:one]).to eq 'two'
          expect(row[:line]).to eq 'lines'
        end
      end
    end

    def file_name
      'spec/fixtures/import_data/open_test.csv'
    end
  end
end
