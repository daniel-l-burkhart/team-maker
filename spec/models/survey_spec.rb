require 'rails_helper'

RSpec.describe Survey, type: :model do

  it 'having an invalid name should fail' do
    survey = Survey.create(name: nil, end_date: DateTime.now+2)
    expect(survey).not_to be_valid
  end

  it 'having valid attributes should pass' do
    survey = Survey.create(name: 'Name', end_date: DateTime.now+2)
    expect(survey).to be_valid
  end

end