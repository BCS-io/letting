require 'rails_helper'
include AddressDefaults

RSpec.describe Address, type: :model do
  describe 'validations' do
    describe 'flat_no' do
      it('allows blanks') { expect(addressable_new flat_no: '').to be_valid }
      it 'has max' do
        expect(addressable_new flat_no: 'a' * (MAX_NUMBER + 1)).to_not be_valid
      end
    end

    describe 'house_name' do
      it('allows blanks') { expect(addressable_new house_name: '').to be_valid }
      it 'has max' do
        expect(addressable_new house_name: 'a' * (MAX_STRING + 1)).to_not be_valid
      end
      it 'has min' do
        expect(addressable_new house_name: 'a' * (MIN_STRING - 1)).to_not be_valid
      end
    end

    describe 'road no' do
      it('allows blanks') { expect(addressable_new road_no: '').to be_valid }
      it 'has max' do
        addressable = addressable_new road_no: 'a' * (MAX_NUMBER + 1)
        addressable.valid?
        expect(addressable.errors.full_messages)
          .to eq ['Road no is too long (maximum is 10 characters)']
      end
    end

    describe 'road' do
      it('is required') { expect(addressable_new road: '').to_not be_valid }
      it 'has max' do
        expect(addressable_new road: 'a' * (MAX_STRING + 1)).to_not be_valid
      end
      it 'has min' do
        expect(addressable_new road: 'a' * (MIN_STRING - 1)).to_not be_valid
      end
    end

    describe 'district' do
      it('allows blanks') { expect(addressable_new district: '').to be_valid }
      it 'has max' do
        expect(addressable_new district: 'a' * (MAX_STRING + 1)).to_not be_valid
      end
      it 'has min' do
        expect(addressable_new district: 'a' * (MIN_STRING - 1)).to_not be_valid
      end
    end

    describe 'town' do
      it('allows blanks') { expect(addressable_new town: '').to be_valid }
      it 'has min' do
        expect(addressable_new town: 'a' * (MIN_STRING - 1)).to_not be_valid
      end
      it('has max') do
        expect(addressable_new town: 'a' * (MAX_STRING + 1)).to_not be_valid
      end
    end

    describe 'county' do
      it('is required') { expect(addressable_new county: '').to_not be_valid }
      it 'has min' do
        expect(addressable_new county: 'a' * (MIN_STRING - 1)).to_not be_valid
      end
      it 'has max' do
        expect(addressable_new county: 'a' * (MAX_STRING + 1)).to_not be_valid
      end
    end

    describe 'postcode' do
      it('allows blanks') { expect(addressable_new postcode: '').to be_valid }
      it 'has min' do
        expect(addressable_new postcode: 'B' * (MIN_POSTCODE - 1)).to_not be_valid
      end
      it 'has max' do
        expect(addressable_new postcode: 'B' * (MAX_POSTCODE + 1)).to_not be_valid
      end
    end

    describe 'nation' do
      it('allows blanks') { expect(addressable_new nation: '').to be_valid }
      it 'has min' do
        expect(addressable_new nation: 'a' * (MIN_STRING - 1)).to_not be_valid
      end
      it 'has max' do
        expect(addressable_new nation: 'a' * (MAX_STRING + 1)).to_not be_valid
      end
    end
  end

  describe 'methods' do
    describe '#name_and_address' do
      it 'presents full name and address' do
        address = Address.new flat_no: '47',
                              house_name: 'Hill Court',
                              town: 'Brum'
        expect(address.name_and_address name: 'Bob')
          .to eq "Bob\nFlat 47 Hill Court\nBrum"
      end
      it 'can override the join' do
        address = Address.new flat_no: '47',
                              house_name: 'Hill Court',
                              town: 'Brum'
        expect(address.name_and_address name: 'Bob', join: ', ')
          .to eq 'Bob, Flat 47 Hill Court, Brum'
      end
    end

    it 'outputs #text' do
      house = Address.new flat_no: '17', road: 'Edge Road', town: 'Brum'
      expect(house.text).to eq "Flat 17\nEdge Road\nBrum"
    end

    describe '#abridged_text' do
      it 'adds flat when present' do
        address = Address.new flat_no: '47', house_name: 'Hill', town: 'Brum'
        expect(address.abridged_text).to eq "Flat 47 Hill\nBrum"
      end
      it 'adds road when flat missing' do
        house = Address.new flat_no: '', road: 'Edge Road', town: 'Brum'
        expect(house.abridged_text).to eq "Edge Road\nBrum"
      end
      it 'adds town when present' do
        house = Address.new road: 'Edge', town: 'Brum', county: 'West'
        expect(house.abridged_text).to eq "Edge\nBrum"
      end
      it 'adds county when town missing' do
        house = Address.new road: 'Edge', town: '', county: 'West'
        expect(house.abridged_text).to eq "Edge\nWest"
      end
    end

    describe '#first_line' do
      it 'shows house when present' do
        address = Address.new flat_no: '47', house_name: 'Hill', road: 'Edge Rd'
        expect(address.first_line).to eq 'Flat 47 Hill'
      end
      it "shows house without 'flat' prefix if no number" do
        address = Address.new flat_no: '', house_name: 'Hill', road: 'Edge Rd'
        expect(address.first_line).to eq 'Hill'
      end
      it 'shows road when flat missing' do
        address = Address.new flat_no: nil, house_name: nil, road: 'Edge Rd'
        expect(address.first_line).to eq 'Edge Rd'
      end
    end

    describe '#first_no' do
      it 'shows flat no when present' do
        address = Address.new flat_no: '47', house_name: 'Hill', road: 'Edge Rd'
        expect(address.first_no).to eq '47'
      end
      it 'shows road no when flat missing' do
        address = Address.new flat_no: nil,
                              house_name: nil,
                              road_no: '8',
                              road: 'Edge Rd'
        expect(address.first_no).to eq '8'
      end
    end

    describe '#first_text' do
      it 'shows flat house when present' do
        address = Address.new flat_no: '47', house_name: 'Hill', road: 'Edge Rd'
        expect(address.first_text).to eq 'Hill'
      end
      it 'shows road when flat missing' do
        address = Address.new flat_no: nil,
                              house_name: nil,
                              road_no: '8',
                              road: 'Edge Rd'
        expect(address.first_text).to eq 'Edge Rd'
      end

      it 'shows road number and address if house name missing' do
        address = Address.new flat_no: 37,
                              house_name: nil,
                              road_no: '8',
                              road: 'Edge Rd'
        expect(address.first_text).to eq '8 Edge Rd'
      end
    end
  end

  def addressable_new \
        flat_no: '',
        house_name: '',
        road_no: '',
        road: 'Edgbaston Road',
        district: '',
        town: 'Birmingham',
        county: 'West Midlands',
        postcode: '',
        nation: ''
    address = address_new flat_no: flat_no,
                          house_name: house_name,
                          road_no: road_no,
                          road: road,
                          district: district,
                          town: town,
                          county: county,
                          postcode: postcode,
                          nation: nation
    address.addressable = client_new
    address
  end
end
