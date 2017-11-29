require 'spec_helper'
require 'rails_helper'

##
# Model Testing for Student objects
##
describe Student do

  it 'has a valid factory' do
    expect(FactoryGirl.create(:student)).to be_valid
  end

  it 'is invalid without a name' do
    expect(FactoryGirl.build(:student, name: nil)).not_to be_valid
  end

  it 'is invalid without a university' do
    expect(FactoryGirl.build(:student, university: nil)).not_to be_valid
  end

  it 'is invalid without a studentId' do
    expect(FactoryGirl.build(:student, student_id: nil)).not_to be_valid
  end


  it 'is invalid without an email' do
    expect(FactoryGirl.build(:student, email: nil)).not_to be_valid
  end

end