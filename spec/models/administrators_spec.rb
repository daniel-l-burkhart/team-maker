require 'spec_helper'
require 'rails_helper'

##
# Testing Administrator model object
##
describe Administrator do

  it 'has a valid factory' do
    expect(FactoryGirl.create(:administrator)).to be_valid
  end

  it 'is invalid without a name' do
    expect(FactoryGirl.build(:administrator, name: nil)).not_to be_valid
  end

  it 'is invalid without a department' do
    expect(FactoryGirl.build(:administrator, department: nil)).not_to be_valid
  end

  it 'is invalid without a university' do
    expect(FactoryGirl.build(:administrator, university: nil)).not_to be_valid
  end

  it 'is invalid without a phone' do
    expect(FactoryGirl.build(:administrator, phone: nil)).not_to be_valid
  end

  it 'is invalid without an email' do
    expect(FactoryGirl.build(:administrator, email: nil)).not_to be_valid
  end

  it 'is invalid without an password' do
    expect(FactoryGirl.build(:administrator, password: nil)).not_to be_valid
  end

end