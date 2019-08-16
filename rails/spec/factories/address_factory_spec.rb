require 'rails_helper'

RSpec.describe 'Address Factory' do
  describe 'address_new' do
    describe 'defaults' do
      it 'errors about missing parent' do
        a = address_new
        a.valid?

        expect(a.errors.size).to eq 1
        expect(a.errors.full_messages).to eq ['Addressable must exist']
      end
      it('has empty flat_no') { expect(address_new.flat_no).to eq '' }
      it('has empty house_name') { expect(address_new.house_name).to eq '' }
      it('has empty road_no') { expect(address_new.road_no).to eq '' }
      it('has road') { expect(address_new.road).to eq 'Edgbaston Road' }
      it('has empty district') { expect(address_new.district).to eq '' }
      it('has town') { expect(address_new.town).to eq 'Birmingham' }
      it('has county') { expect(address_new.county).to eq 'West Midlands' }
      it('has empty postcode') { expect(address_new.postcode).to eq '' }
      it('has empty nation') { expect(address_new.nation).to eq '' }
    end
  end

  describe 'overrides' do
    it('alters flat_no') { expect(address_new(flat_no: '1').flat_no).to eq '1' }
    it 'alters house_name' do
      expect(address_new(house_name: 'old').house_name).to eq 'old'
    end
    it('alters road_no') { expect(address_new(road_no: '5').road_no).to eq '5' }
    it('alters road') { expect(address_new(road: 'Lond').road).to eq 'Lond' }
    it 'alters district' do
      expect(address_new(district: 'Eal').district).to eq 'Eal'
    end
    it('alters town') { expect(address_new(town: 'Bath').town).to eq 'Bath' }
    it('alters county') { expect(address_new(county: 'Kt').county).to eq 'Kt' }
    it 'alters postcode' do
      expect(address_new(postcode: 'KJ').postcode).to eq 'KJ'
    end
    it('alters nation') { expect(address_new(nation: 'Sp').nation).to eq 'Sp' }
  end
end
