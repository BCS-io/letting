# rubocop: disable Metrics/LineLength

require 'rails_helper'

RSpec.describe Guide, type: :model do
  describe 'validations' do
    it('returns valid') { expect(guide_new).to be_valid }
    it('needs instruction') { expect(guide_new instruction: '').to_not be_valid }
    it('needs fillin') { expect(guide_new fillin: '').to_not be_valid }
    it('needs sample') { expect(guide_new sample: '').to_not be_valid }
    it('instruction 25 char valid') { expect(guide_new instruction: 'I' * 100).to be_valid }
    it('instruction above 25 char invalid') { expect(guide_new instruction: 'I' * 101).to_not be_valid }
    it('fillin 25 char valid') { expect(guide_new fillin: 'F' * 100).to be_valid }
    it('fillin above 25 char invalid') { expect(guide_new fillin: 'F' * 101).to_not be_valid }
    it('sample 25 char valid') { expect(guide_new sample: 'S' * 25).to be_valid }
    it('sample above 25 char invalid') { expect(guide_new sample: 'S' * 26).to_not be_valid }
  end
end
