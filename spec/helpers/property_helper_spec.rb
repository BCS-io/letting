require 'rails_helper'

describe PropertyHelper, type: :helper do
  it '#lists clients' do
    client_create id: 1,
                  human_ref: '8008',
                  entities: [Entity.new(title: 'Mr', name: 'Bell')]

    expect(client_list.first).to eq ['8008 Mr Bell', 1]
  end
end
