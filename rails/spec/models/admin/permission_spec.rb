require 'rails_helper'
require_relative '../../../app/models/admin/permission'

RSpec::Matchers.define :allow? do |*args|
  match do |permission|
    expect(permission.allow?(*args)).to be true
  end
end

RSpec.describe Permission, type: :model do
  context 'with a guest' do
    subject { described_class.new(nil) }

    it('session#new') { is_expected.to allow?('sessions', 'new') }
    it('session#create') { is_expected.to allow?('sessions', 'create') }
    it('session#destroy') { is_expected.to allow?('sessions', 'destroy') }

    it('properties#index') { is_expected.not_to allow?('properties', 'index') }
    it('properties#create') { is_expected.not_to allow?('properties', 'create') }
    it('properties#edit') { is_expected.not_to allow?('properties', 'edit') }
    it('properties#update') { is_expected.not_to allow?('properties', 'update') }
    it('properties#destroy') { is_expected.not_to allow?('properties', 'destroy') }

    it('clients#index') { is_expected.not_to allow?('clients', 'index') }
    it('clients#create') { is_expected.not_to allow?('clients', 'create') }
    it('clients#edit') { is_expected.not_to allow?('clients', 'edit') }
    it('clients#update') { is_expected.not_to allow?('clients', 'update') }
    it('clients#destroy') { is_expected.not_to allow?('clients', 'destroy') }

    it('cycles#index') { is_expected.not_to allow?('cycles', 'index') }
    it('cycles#create') { is_expected.not_to allow?('cycles', 'create') }
    it('cycles#edit') { is_expected.not_to allow?('cycles', 'edit') }
    it('cycles#update') { is_expected.not_to allow?('cycles', 'update') }
    it('cycles#destroy') { is_expected.not_to allow?('cycles', 'destroy') }

    it('users#index') { is_expected.not_to allow?('users', 'index') }
    it('users#create') { is_expected.not_to allow?('users', 'create') }
    it('users#edit') { is_expected.not_to allow?('users', 'edit') }
    it('users#update') { is_expected.not_to allow?('users', 'update') }
    it('users#destroy') { is_expected.not_to allow?('users', 'destroy') }
  end

  context 'with a user' do
    subject { described_class.new(user_create role: 'user') }

    it('session#new')      { is_expected.to allow?('sessions', 'new') }
    it('session#create')   { is_expected.to allow?('sessions', 'create') }
    it('session#destroy')  { is_expected.to allow?('sessions', 'destroy') }

    it('properties#index')   { is_expected.to allow?('properties', 'index') }
    it('properties#create')  { is_expected.to allow?('properties', 'create') }
    it('properties#edit')    { is_expected.to allow?('properties', 'edit') }
    it('properties#update')  { is_expected.to allow?('properties', 'update') }
    it('properties#destroy') { is_expected.to allow?('properties', 'destroy') }

    it('clients#index') { is_expected.to allow?('clients', 'index') }
    it('clients#create') { is_expected.to allow?('clients', 'create') }
    it('clients#edit') { is_expected.to allow?('clients', 'edit') }
    it('clients#update') { is_expected.to allow?('clients', 'update') }
    it('clients#destroy') { is_expected.to allow?('clients', 'destroy') }

    it('cycles#index') { is_expected.not_to allow?('cycles', 'index') }
    it('cycles#create') { is_expected.not_to allow?('cycles', 'create') }
    it('cycles#edit') { is_expected.not_to allow?('cycles', 'edit') }
    it('cycles#update') { is_expected.not_to allow?('cycles', 'update') }
    it('cycles#destroy') { is_expected.not_to allow?('cycles', 'destroy') }
  end

  context 'with an admin' do
    subject { described_class.new(user_create role: 'user') }

    it('users#index') { is_expected.not_to allow?('users', 'index') }
    it('users#create') { is_expected.not_to allow?('users', 'create') }
    it('users#edit') { is_expected.not_to allow?('users', 'edit') }
    it('users#update') { is_expected.not_to allow?('users', 'update') }
    it('users#destroy') { is_expected.not_to allow?('users', 'destroy') }
  end

  context 'with an admin' do
    subject { described_class.new(user_create role: 'admin') }

    it('session#destroy') { is_expected.to allow?('sessions', 'destroy') }
    it('clients#destroy') { is_expected.to allow?('clients', 'destroy') }
    it('properties#destroy') { is_expected.to allow?('properties', 'destroy') }

    it('users#index') { is_expected.to allow?('users', 'index') }
    it('users#create') { is_expected.to allow?('users', 'create') }
    it('users#edit') { is_expected.to allow?('users', 'edit') }
    it('users#update') { is_expected.to allow?('users', 'update') }
    it('users#destroy') { is_expected.to allow?('users', 'destroy') }
  end
end
