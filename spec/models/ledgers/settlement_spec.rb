require 'rails_helper'

describe Settlement, :ledgers, type: :model do
  describe 'resolve' do
    describe 'matched settlement' do
      it 'completes when settlement == offset' do
        offset = credit_create charge: charge_new, amount: 3.00
        expect { |b| Settlement.resolve(3.00, [offset], &b) }
          .to yield_with_args(offset, 3.00)
      end

      it 'completes when settlement == summed offsets' do
        charge = charge_new
        offsets = [credit_create(charge: charge, amount: 4.00),
                   credit_create(charge: charge, amount: 2.00)]
        expect { |b| Settlement.resolve(6.00, offsets, &b) }
          .to yield_successive_args([offsets[0], 4.00], [offsets[1], 2.00])
      end

      it 'handles debit being offset' do
        offset = debit_create charge: charge_new, amount: 3.00
        expect { |b| Settlement.resolve(3.00, [offset], &b) }
          .to yield_with_args(offset, 3.00)
      end

      it 'handles summed debits being offset' do
        chrge = charge_new
        offsets = [debit_create(charge: chrge, on_date: '25/3/2013', amount: 3),
                   debit_create(charge: chrge, on_date: '25/3/2014', amount: 3)]
        expect { |b| Settlement.resolve(6.00, offsets, &b) }
          .to yield_successive_args([offsets[0], 3.00], [offsets[1], 3.00])
      end
    end

    describe 'maximum settlement' do
      it 'returns a settlement no more than settle ' do
        offset = credit_create charge: charge_new, amount: 5.00
        expect { |b| Settlement.resolve(4.00, [offset], &b) }
          .to yield_with_args(offset, 4.00)
      end

      it 'returns a settlement no more than offset(s)' do
        offset = credit_create charge: charge_new, amount: 3.00
        expect { |b| Settlement.resolve(4.00, [offset], &b) }
          .to yield_with_args(offset, 3.00)
      end
    end
  end
end
