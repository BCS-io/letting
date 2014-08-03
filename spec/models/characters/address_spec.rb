require 'spec_helper'

describe Address, type: :model do

  let(:address) { Address.new min_address_attributes }
  it('valid')   { expect(address).to be_valid }

  describe 'validations' do

    describe 'flat_no' do
      it 'allows blanks' do
        address.flat_no = ''
        expect(address).to be_valid
      end

      it 'has max' do
        address.flat_no = 'a' * 11
        expect(address).to_not be_valid
      end
    end

    describe 'house_name' do
      it 'allows blanks' do
        address.house_name = ''
        expect(address).to be_valid
      end

      it 'has max' do
        address.house_name = 'a' * 65
        expect(address).to_not be_valid
      end
    end

    describe 'road no' do
      it 'allows blanks'  do
        address.road_no = ''
        expect(address).to be_valid
      end

      it 'has max' do
        address.road_no = 'a' * 11
        expect(address).to_not be_valid
      end
    end

    describe 'road' do
      it 'has to be present' do
        address.road = ''
        expect(address).to_not be_valid
      end

      it 'road has a max' do
        address.road = 'a' * 65
        expect(address).to_not be_valid
      end
    end

    describe 'district' do
      it 'allows blanks' do
        address.district = ''
        expect(address).to be_valid
      end

      it 'has min' do
        address.district = 'a'
        expect(address).to_not be_valid
      end

      it 'has max' do
        address.district = 'a' * 65
        expect(address).to_not be_valid
      end
    end

    describe 'town' do
      it 'allows blanks' do
        address.town = ''
        expect(address).to be_valid
      end

      it 'has min' do
        address.town = 'a'
        expect(address).to_not be_valid
      end

      it 'has max' do
        address.town = 'a' * 65
        expect(address).to_not be_valid
      end
    end

    describe 'county' do
      it 'must be present' do
        address.county = nil
        expect(address).to_not be_valid
      end

      it 'has min' do
        address.county = 'a'
        expect(address).to_not be_valid
      end

      it 'has max' do
        address.county = 'a' * 65
        expect(address).to_not be_valid
      end
    end

    describe 'postcode' do
      it 'has min' do
        address.postcode = 'B7'
        expect(address).to_not be_valid
      end
      it 'has max' do
        address.postcode = 'B' * 21
        expect(address).to_not be_valid
      end
    end

    describe 'nation' do
      it 'allows blanks' do
        address.nation = ''
        expect(address).to be_valid
      end

      it 'has min' do
        address.nation = 'a'
        expect(address).to_not be_valid
      end

      it 'has max' do
        address.nation = 'a' * 65
        expect(address).to_not be_valid
      end
    end
  end

  describe 'methods' do
    describe '#address_lines' do
      it 'writes flat property' do
        address = Address.new address_attributes
        expect(address.address_lines).to contain_exactly \
          'Flat 47 Hillbank House',
          '294 Edgbaston Road',
          'Edgbaston',
          'Birmingham',
          'West Midlands',
          'B5 7QU'
      end

      it 'writes house from road' do
        house = Address.new house_address_attributes
        expect(house.address_lines[0]).to eq '294 Edgbaston Road'
      end
    end

    describe 'abbreviated_address' do
      it 'generates flat address' do
        address = Address.new address_attributes
        expect(address.abbreviated_address).to eq 'Flat 47 Hillbank House'
      end
      it 'generates house address' do
        house = Address.new house_address_attributes
        expect(house.abbreviated_address).to eq '294 Edgbaston Road'
      end
    end

    context '#empty?' do
      let(:address) { Address.new }
      it 'empty' do
        expect(address).to be_empty
      end

      it 'with noted attribute not empty' do
        address.town = 'Bath'
        expect(address).to_not be_empty
      end

      it 'with ignored attribute empty' do
        address.id = 8
        expect(address).to be_empty
      end
    end

    it 'Limits attributes copied' do
      client = client_new
      new_address = Address.new
      new_address.attributes = client.address.copy_approved_attributes
      expect(new_address.addressable_id).to be_nil
      expect(new_address.road).to be_present
    end
  end
end