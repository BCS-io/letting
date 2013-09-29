require 'spec_helper'

describe Address do

  let(:address) do
    Address.new road_no: '1', road: 'my road', town: 'my town', county: 'my county'
  end

  it ('valid') { expect(address).to be_valid }

  context 'validations' do
    context 'presence' do
      it('#county')  { address.county =nil; expect(address).not_to be_valid }
      it('#road')    { address.road =nil; expect(address).not_to be_valid }
    end

    it ('flat_no can be blank')       { address.flat_no = '';expect(address).to be_valid }
    it ('flat_no has maximum length') { address.flat_no = 'a' * 11; expect(address).to_not be_valid }

    it ('house_name can be blank')       { address.house_name = ''; expect(address).to be_valid }
    it ('house_name has maximum length') { address.house_name = 'a' * 65; expect(address).to_not be_valid }

    it ('road_no can be blank if house_name is set')  do
      address.road_no = ''
      address.house_name = 'my house'
      expect(address).to be_valid
    end

    it ('road_no has a maximum length') {address.road_no = 'a' * 11; expect(address).to_not be_valid }

    it ('road has to be present') { address.road = ''; expect(address).to_not be_valid }
    it ('road has a maximum length') { address.road = 'a' * 65; expect(address).to_not be_valid }

    it ('district can be blank') { address.district = ''; expect(address).to be_valid }
    it ('district has a minimum length') { address.district = 'aa'; expect(address).to_not be_valid }
    it ('district has a maximum length') { address.district = 'a' * 65; expect(address).to_not be_valid }

    it ('town can be blank') { address.town = ''; expect(address).to be_valid }
    it ('town has a minimum length') { address.town = 'aa'; expect(address).to_not be_valid }
    it ('town has a maximum length') { address.town = 'a' * 65; expect(address).to_not be_valid }

    it ('county cannot be blank')      { address.county = ''; expect(address).to_not be_valid }
    it ('county has a minimum length') { address.county = 'aa'; expect(address).to_not be_valid }
    it ('county has a maximum length') { address.county = 'a' * 65; expect(address).to_not be_valid }

    it ('postcode has a valid form') { address.postcode = 'B75 6NR'; expect(address).to be_valid }
    it ('postcode has an invalid form') { address.postcode = 'B7'; expect(address).to_not be_valid }

  end

  context 'associations' do
    it('is addressable') { expect(address).to respond_to :addressable }
  end

  context 'methods #empty? new address' do
    let(:address) { Address.new }
    it('empty') { expect(address).to be_empty }
    it('with noted attribute not empty') { address.town = 'Bath'; expect(address).to_not be_empty }
    it('with ignored attribute empty') { address.id = 8; expect(address).to be_empty}
  end

  it 'Limits attributes copied' do
    client = client_new
    new_address = Address.new
    new_address.attributes = client.address.copy_approved_attributes
    expect(new_address.addressable_id).to be_nil
    expect(new_address.road).not_to be_nil
  end


  # Note search automatically uses ordered asc search
  context 'search' do

    a2 = a1 = nil
    before do
      a1 = Address.create! addressable_id: 1, \
                           addressable_type: 'Client', \
                           house_name: 'Hillbank', \
                           road: 'Edgbaston Road', \
                           town: 'Birmingham', \
                           county: 'West Midlands'

      a2 = Address.create! addressable_id: 1, \
                           addressable_type: 'Client', \
                           house_name: 'Headingly', \
                           road: 'Headingly', \
                           town: 'York', \
                           county: 'Yorkshire'

      expect(Address.all).to eq [a1,a2]
    end

    it('house') { expect(Address.search_by_all 'Hill').to eq [a1] }
    it('road')  { expect(Address.search_by_all 'Edg').to  eq [a1] }
    it('towns') { expect(Address.search_by_all 'Yor').to  eq [a2] }
  end
end
