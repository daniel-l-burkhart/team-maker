require 'spec_helper'
require 'rails_helper'

##
# Model testing for faculty objects.
##
describe Faculty do

  it 'has a valid factory' do
    expect(FactoryGirl.create(:faculty)).to be_valid
  end

  it 'is invalid without a name' do
    expect(FactoryGirl.build(:faculty, name: nil)).not_to be_valid
  end

  it 'is invalid without a department' do
    expect(FactoryGirl.build(:faculty, department: nil)).not_to be_valid
  end

  it 'is invalid without a university' do
    expect(FactoryGirl.build(:faculty, university: nil)).not_to be_valid
  end

  it 'is invalid without a phone' do
    expect(FactoryGirl.build(:faculty, phone: nil)).not_to be_valid
  end

  it 'is invalid without an email' do
    expect(FactoryGirl.build(:faculty, email: nil)).not_to be_valid
  end

end