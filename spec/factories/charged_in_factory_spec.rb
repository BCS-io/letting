require 'rails_helper'

describe 'ChargedIn Factory' do
  describe 'new' do
    context 'default' do
      it('is valid') { expect(charged_in_new).to be_valid }
      it('has default name') { expect(charged_in_create.name).to eq 'Advance' }
      it('has default id') { expect(charged_in_new.id).to eq(2) }
    end
  end

  describe 'create' do
    context 'default' do
      it 'is created' do
        expect { charged_in_create }.to change(ChargedIn, :count).by(1)
      end
    end

    it 'finds if the name is known and creates when the name is unknown' do
      charged_in_create name: 'Advance'
      charged_in_create name: 'Advance'
      expect(ChargedIn.count).to eq 1
    end
  end

  describe 'charged_in_name' do
    it 'finds name when present' do
      charged_in_create id: 2, name: 'Advance'
      expect(charged_in_name(id: 2)).to eq 'Advance'
    end
  end
end
