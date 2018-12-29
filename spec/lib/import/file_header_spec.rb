require 'rails_helper'
require_relative '../../../lib/import/file_header'

module DB
  describe FileHeader, :import do
    it 'client' do
      fields =
        %w[
          human_ref
          title1 initials1 name1
          title2 initials2 name2
          flat_no house_name road_no road district town county postcode
        ]
      expect(FileHeader.client).to eq fields
    end

    it 'property' do
      fields =
        %w[
          human_ref updated
          title1 initials1 name1
          title2 initials2 name2
          flat_no house_name road_no road district town county postcode
          client_ref
        ]
      expect(FileHeader.property).to eq fields
    end

    it 'agent' do
      fields =
        %w[
          human_ref
          title1 initials1 name1
          title2 initials2 name2
          flat_no house_name road_no road district town county postcode nation
        ]
      expect(FileHeader.agent).to eq fields
    end

    it 'agent patch' do
      fields =
        %w[
          human_ref
          title1 initials1 name1
          title2 initials2 name2
          flat_no house_name road_no road district town county postcode
          nation override
        ]
      expect(FileHeader.agent_patch).to eq fields
    end

    it 'user' do
      fields = %w[nickname email password role]
      expect(FileHeader.user).to eq fields
    end
  end
end
